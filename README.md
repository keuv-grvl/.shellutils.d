# .shellutil.d/

Collection of shell aliases and functions.

# Usage

## Installation

``` bash
cd $HOME/
git clone ...
```

## Usage

Add to you `.bashrc` or `.zshrc`:

``` bash
for F in $(ls $HOME/.shellutil.d/*.sh); do
  source $HOME/.shell_aliases.sh
done;
```

## Update

``` bash
cd $HOME/.shellutil.d/
git pull
```
