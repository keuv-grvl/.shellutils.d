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
source ~/.$(basename $SHELL)rc
```
