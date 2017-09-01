# ~/.shellutils.d/

Collection of shell aliases and functions.

# Usage

## Installation

``` bash
cd $HOME/
git clone https://github.com/keuv-grvl/.shellutils.d.git
```

Then add the following to you `.bashrc`, `.zshrc` or `.your_shellrc`:

``` bash
for F in $(ls $HOME/.shellutils.d/*.sh); do
  source $F
done;
```

## Update

``` bash
cd $HOME/.shellutils.d/
git pull
source ~/.$(basename $( command -v -- "$0" >/dev/null && echo $(command -v -- "$0") || echo "$SHELL") )rc
```

# Functions

| Command | Description |
|---|---|
| `ret`               | Get return code of last command |
| `load`              | Print load |
| `memu`              | Print memory usage |
| `disku (<FOLDER>)`  | Print disk usage (default: `$HOME`)|
| `maxproc`           | Print max number of "free" CPU |
| `mkcd <FOLDER>`     | Make a directory a move into it |
| `cdmem`             | Move to `/dev/shm/$USER/` |
| `dl <URL>`          | Download a file from its URL |
| `extract <ARCHIVE>` | Extract any archive |
| `hashall <FILES>`   | Compute and store MD5 hash for a list of file |
| `checkall <*.md5>`  | Check multiple MD5 hash |
| `pingssh`           | Ping SSH servers from you `$HOME/.ssh/config` file |
| `md2pdf <FILE.md`   | Convert Markdown to PDF using pandoc |
| `gpuload`           | Print GPU usage for NVidia graphic cards |
| `beep`              | Play a sound (see `beep list`) |
