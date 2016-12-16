# ~/.shellutils.d/

Collection of shell aliases and functions.

# Usage

## Installation

``` bash
cd $HOME/
git clone https://github.com/keuv-grvl/.shellutils.d.git
```

## Usage

Add to you `.bashrc` or `.zshrc`:

``` bash
for F in $(ls $HOME/.shellutils.d/*.sh); do
  source $F
done;
```

## Update

``` bash
cd $HOME/.shellutils.d/
git pull
```
