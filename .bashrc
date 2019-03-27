#!/bin/bash

# git
source ".gitprompt.sh"

USERCOLOR="\[\033[38;5;4m\]"
ROOTCOLOR="\[\033[31m\]"
HOSTCOLOR="\[\033[38;5;226m\]"
DIRCOLOR="\[\033[32m\]"
WHITECOLOR="\[\033[00m\]"
TIMECOLOR="\[\033[38;5;208m\]"
ROOTDIRCOLOR="\[\033[38;5;196m\]"

BOLD="\[\e[1m\]"
NORMAL="\[\e[0m\]"

PS1=""

# time
PS1+="$TIMECOLOR[\t] $WHITECOLOR$BOLD"

# user@host
if [[ ${EUID} == 0 ]] ; then
	PS1+=$ROOTCOLOR
else
	PS1+=$USERCOLOR
fi
PS1+="\u$WHITECOLOR$NORMAL@$BOLD$HOSTCOLOR\h$NORMAL$WHITECOLOR: "

# directory
if [[ ${EUID} == 0 ]] ; then
    PS1+="$ROOTDIRCOLOR"
else
	PS1+="$DIRCOLOR"
fi

PS1+="$BOLD\w "

# git
PS1+="$GITBRANCH"

PS1+="$NORMAL$WHITECOLOR\n▶▶ "

export PS1

PS2=">>"

export PS2

source ~/.git-completion.bash

alias ls='ls --color'
alias grep='grep --color'
alias ll='ls -la'
alias cp='cp -i'

alias lld='ll -rt'
alias mkdir='mkdir -pv'
mktar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }    # Creates a *.tar.gz archive of a file or folder
mkzip() { zip -r "${1%%/}.zip" "$1" ; }               # Create a *.zip archive of a file or folder

alias dockerc='docker-compose'
