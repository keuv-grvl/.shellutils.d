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
command -v xsel >/dev/null && alias clip='xsel --clipboard'

# delete gedit temp files
alias cleantilde='find . -name "*~" -delete'

# misc
alias dl='dwld'
alias htopu='htop -u $USER'

alias please="sudo"
alias plz="sudo"
