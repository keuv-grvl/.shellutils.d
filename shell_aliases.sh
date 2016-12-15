
### ALIASES ###

# ls
alias l='ls -CF'
alias la='ls -ACF'
alias ll='ls -gFh'
alias lla='ls -laFh'

# Add an "alert" alias for long running commands.
# usage: sleep 10; alert
alias alert='notify-send -i "$([ $? = 0 ] && echo terminal || echo error)" "$([ $? = 0 ] && echo Completed || echo Error)" "$(history|tail -n1|sed -r "s/^\s*[0-9]+\s*//; s/\s*[;&|]\s*alert.*$//")"'

# copy output to clipboard
# usage: pwd | clip
which xsel > /dev/null && alias clip='xsel --clipboard'

# delete gedit temp files
alias cleantilde='find . -name "*~" -delete'

# git
alias g="git"
alias gi="git init"
alias gcf="git config"
alias gs="git status -sb"
alias gls="git status"
alias gl="git log --oneline --decorate"
alias ga="git add"
alias gc="git commit"
alias gd="git diff --word-diff"
alias gpl="git pull"
alias gps="git push"
alias gck="git checkout"
alias gb="git branch -a"
alias gbn="git branch"
alias gbr="git branch -D"
alias gbrr="git push origin --delete "

which thefuck > /dev/null && eval "$(thefuck --alias)"
which thefuck > /dev/null && eval "$(thefuck --alias merde)"
