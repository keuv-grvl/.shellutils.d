#!/usr/bin/env bash

### FUNCTIONS ###

# make and go to dir
function mkcd {
  mkdir -p "$1" && cd "$1"
}

# move to temp dir
function tmpcd {
  cd "$(mktemp -d "/tmp/tmp.$(date +%s).XXX")"
  pwd
}

# make dir into RAM (avoiding conflict with other users)
function memcd {
  mkdir -p "/dev/shm/$USER" && cd "/dev/shm/$USER"
}

# print status code of the last command
function ret {
  r=$?
  echo $r
  (exit $r)
}

# download using curl
function dwld {
  curl -OL "$@"
}

# upload file to https://transfer.sh/
function upld {
  if [ $# -eq 0 ]; then
    echo -e "usage: $0 <FILE>"
    return 1
  fi
  tmpfile=$(mktemp -t $0XXX)
  basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g')
  curl --upload-file "$1" "https://transfer.sh/$basefile" -o $tmpfile
  echo $(cat $tmpfile)
  rm -f $tmpfile
}

# load = (loadavg / nproc * 100)
function load {
  echo "$(awk '{print $1}' /proc/loadavg)" "$(nproc)" |
    awk '{ printf("%.2f%% (%.2f/%i)\n", $1/$2*100, $1, $2) }'
}

# memory usage (as in gnome-system-monitor, cached memory is not considered)
function memu {
  free |
    awk 'NR==2{print}' |
    sed -r 's/\s{2,}/\t/g' |
    awk -F "\t" '{printf "%.2f%% (%.2f/%.2fGB)\n", ($3 / $2 * 100), $3/1024/1024, $2/1024/1024}'
}

# disk usage (of $HOME by default)
function disku {
  DIR=$HOME
  [ ! -z "$1" ] && DIR="$1"
  df "$DIR" |
    awk 'NR==2{printf("%.2f%% (%.2f/%.2fGB)\n", $3/$2*100, $3/1024/1024 , ($2)/1024/1024)}'
}

# max number of "free" CPU = max(1, (number of CPU - current load))
function maxproc {
  echo $(nproc --ignore=$(awk '{printf "%.0f\n", ($1 + 0.5)}' /proc/loadavg))
}

# compute and store MD5hash of a list of file
function hashall {
  echo "$@" |
    tr ' ' '\n' |
    grep -vE ".md5$" |
    xargs -I F -P"$(maxproc)" \
      bash -c "echo '- F' ; md5sum F > F.md5"
}

# check MD5sum from .md5 file (usage: checkall *.md5)
function checkall {
  echo "$@" |
    tr ' ' '\n' |
    xargs -I F -P"$(maxproc)" \
      bash -c "md5sum -c F"
}

# list hostnames in you $HOME/.ssh/config and ping them
# /!\ Some servers may be configured to not respond to ping
function pingssh {
  [ -f "$HOME/.ssh/config" ] &&
    (grep -i "hostname" "$HOME/.ssh/config" |
      awk '{print $NF}' |
      xargs -I IP -n1 -P30 \
        bash -c "ping -w1 -c1 IP 2>&1 >/dev/null && echo -e '\e[32m⚫\e[0m IP' || echo -e '\e[31m❌\e[0m IP'") ||
    echo "No SSH config found."
}

# extract any archive
function extract {
  if [ -f "$1" ]; then
    case "$1" in
    *.tar.bz2) tar xvjf "$1" ;;
    *.tar.gz) tar xvzf "$1" ;;
    *.tar.xz) tar Jxvf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar x "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xvf "$1" ;;
    *.tbz2) tar xvjf "$1" ;;
    *.tgz) tar xvzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *.zst) zstd -d "$1" ;;
    *.lz4) lz4 -d "$1" ;;
    *) echo "Don't know how to extract '$1'..." ;;
    esac
  else
    echo "'$1' is not a valid file!"
  fi
}

# convert a .md file to PDF using pandoc
function md2pdf {
  fullfile="$1"
  OUT=$(basename "$fullfile" .md)
  pandoc -s -V geometry:margin=1in -V documentclass:article -V fontsize=12pt "${fullfile}" -o "${OUT}.pdf"
}

# print GPU usage (if 'nvidia-smi' is installed)
function gpuload {
  command -v nvidia-smi >/dev/null 2>&1 &&
    (nvidia-smi --query-gpu=utilization.gpu,utilization.memory --format=csv,noheader,nounits |
      awk -F", " '{print "GPU load: "$1"%\nGPU mem. usage: "$2"%"}') ||
    echo "No GPU found"
}

# deeply inspired from R package beepR
# usage: beep list ; beep coin ; sleep 4 && beep treasure
function beep {
  PLAYER="paplay"
  [ "$(uname)" = "Darwin" ] && PLAYER="afplay"
  SOUNDS_DIR="$HOME/.shellutils.d/sounds"
  DEFAULT_SOUND="ping.wav"

  if [ "$1" = "list" ]; then
    find "$SOUNDS_DIR" -maxdepth 1 -mindepth 1 -type f -exec sh -c 'echo $(basename {} .wav)' \;
  else
    if [ -f "$SOUNDS_DIR/$1.wav" ]; then
      $PLAYER "$SOUNDS_DIR/$1.wav"
    else
      $PLAYER "$SOUNDS_DIR/$DEFAULT_SOUND"
    fi
  fi
}

# run the given command in the queue
function queue {
  echo "See: https://github.com/justanhduc/task-spooler"
}



function killscreens {
  screen -ls | grep Detached | cut -d. -f1 | awk '{print $1}' | xargs kill
}

function valheim-pull {
  git -C $HOME/.valheim/worlds pull
  git -C $HOME/.valheim/characters pull
}

function valheim-push {
  git -C $HOME/.valheim/worlds commit -m "$(date)" Delfworld.db Delfworld.fwl
  git -C $HOME/.valheim/worlds push
  git -C $HOME/.valheim/characters commit -m "$(date)" keuv.fch
  git -C $HOME/.valheim/characters push
}

function qrclip {
  xclip -o -s c | qrencode -o - | feh --force-aliasing -ZF -
}
