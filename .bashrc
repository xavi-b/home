#!/bin/bash

source .gitprompt.sh

USERCOLOR="\033[38;5;4m"
ROOTCOLOR="\033[31m"
HOSTCOLOR="\033[38;5;226m"
DIRCOLOR="\033[32m"
WHITECOLOR="\033[00m"
TIMECOLOR="\033[38;5;208m"
ROOTDIRCOLOR="\033[38;5;196m"

BOLD="\e[1m"
NORMAL="\e[0m"

PS1=""

# time
PS1+=$TIMECOLOR
PS1+='[\t] '
PS1+=$WHITECOLOR$BOLD

# user@host
if [[ ${EUID} == 0 ]] ; then
	PS1+=$ROOTCOLOR
else
	PS1+=$USERCOLOR
fi
PS1+='\u'
PS1+=$WHITECOLOR$NORMAL
PS1+='@'
PS1+=$BOLD$HOSTCOLOR
PS1+='\h'
PS1+=$NORMAL$WHITECOLOR
PS1+=': '

# directory
if [[ ${EUID} == 0 ]] ; then
    PS1+=$ROOTDIRCOLOR
else
	PS1+=$DIRCOLOR
fi

PS1+=$BOLD
PS1+='\w '
PS1+=$NORMAL

# git
PS1+='$(getGitStatus)'

PS1+=$NORMAL$WHITECOLOR
PS1+='\n▶▶ '

export PS1

PS2='>>'

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
