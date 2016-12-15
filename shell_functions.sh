
### FUNCTIONS ###

# make and go to dir
function mkcd { 
  mkdir -p $1 && cd $1 
}

# load = (loadavg / nproc * 100)
function load {
  echo $(awk '{print $1}' /proc/loadavg )" "$(nproc) | awk '{ printf "%.2f%% (%.2f/%d)\n", $1/$2*100, $1, $2 }'
}

# memory usage (as in gnome-system-monitor, cached memory is not considered)
function memu {
  free | awk 'NR==2{print}' | sed -r 's/\s{2,}/\t/g' | awk -F "\t" '{printf "%.2f%% (%.2f/%.2fGB)\n", ($2-$4-$7)/($2)*100, ($2-$4-$7)/1024/1024, ($2)/1024/1024}'
}

# disk usage
function disku {
  df $HOME | awk 'NR==2{printf("%.2f%% (%.2f/%dGB)\n", $3/$2*100, $3/1024/1024 , ($2)/1024/1024)}'
}

# download using curl
function dl {
  curl -OL $@
}

# max number of "free" CPU = max(1, (number of processor - current load))
function maxproc {
  nproc=$(grep -c "processor" /proc/cpuinfo)
  load=$(cat /proc/loadavg | awk '{printf "%.0f\n", ($1 + 0.5)}')
  maxproc=$(( $nproc - $load ))
  [ $maxproc -lt 1 ] && echo 1 || echo $(($maxproc))
}

# compute and store MD5hash of a list of file
function hashall {
  echo $@ \
  | tr ' ' '\n' \
  | grep -vE ".md5$" \
  | xargs -I F -P$(maxproc) \
    bash -c "echo '- F' ; md5sum F > F.md5"
}

# check MD5sum from .md5 file (usage: checkall *.md5)
function checkall {
  echo $@ \
  | tr ' ' '\n' \
  | xargs -I F -P$(maxproc) \
    bash -c "md5sum -c F"
}

# list hostnames in you ~/.ssh/config and ping them
# - Some servers has been configured to not respond to ping
function pingssh {
  cat $HOME/.ssh/config \
  | grep -i "hostname" \
  | awk '{print $NF}' \
  | xargs -I IP -n1 -P30 \
    bash -c "ping -c1 IP 2>&1 >/dev/null && echo -e 'IP\treachable' || echo -e 'IP\tnot reachable'"
}

# extract any archive
function extract {
   if [ -f $1 ] ; then
     case $1 in
      *.tar.bz2)      tar xvjf $1 ;;
      *.tar.gz)       tar xvzf $1 ;;
      *.tar.xz)       tar Jxvf $1 ;;
      *.bz2)          bunzip2 $1 ;;
      *.rar)          unrar x $1 ;;
      *.gz)           gunzip $1 ;;
      *.tar)          tar xvf $1 ;;
      *.tbz2)         tar xvjf $1 ;;
      *.tgz)          tar xvzf $1 ;;
      *.zip)          unzip $1 ;;
      *.Z)            uncompress $1 ;;
      *.7z)           7z x $1 ;;
      *)              echo "Don't know how to extract '$1'..." ;;
     esac
   else
     echo "'$1' is not a valid file!"
   fi
}

# convert a .md file to PDF using pandoc
function md2pdf {
  fullfile=$1
  filename=$(basename "$fullfile")
  OUT="${filename%.*}"
  pandoc -s -V geometry:margin=1in -V documentclass:article -V fontsize=12pt "$fullfile" -o "$OUT.pdf"
}
