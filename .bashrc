#!/bin/bash

source ~/.bash/docker
source ~/.bash/docker-compose
source ~/.bash/git-completion.bash
source ~/.bash/gitprompt.sh
source ~/.bash/hostcolor.sh

if [[ -z "$HOSTCOLOR" ]]; then
    HOSTCOLOR="\033[38;5;226m"
fi

USERCOLOR="\033[38;5;4m"
ROOTCOLOR="\033[31m"
DIRCOLOR="\033[32m"
RESETCOLOR="\033[00m"
TIMECOLOR="\033[38;5;208m"
ROOTDIRCOLOR="\033[38;5;196m"

BOLD="\e[1m"
NORMAL="\e[0m"

PS1=""

# time
PS1+=$TIMECOLOR
PS1+='[\t] '
PS1+=$RESETCOLOR$BOLD

# user@host
if [[ ${EUID} == 0 ]] ; then
	PS1+=$ROOTCOLOR
else
	PS1+=$USERCOLOR
fi
PS1+='\u'
PS1+=$RESETCOLOR$NORMAL
PS1+='@'
PS1+=$BOLD$HOSTCOLOR
PS1+='\h'
PS1+=$NORMAL$RESETCOLOR
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

PS1+=$NORMAL$RESETCOLOR
PS1+='\n▶▶ '

export PS1

PS2='>>'

export PS2

alias ls='ls --color'
alias grep='grep --color'
alias ll='ls -lha'
alias cp='cp -i'
alias diff='diff --color'

alias lld='ll -rt'
alias mkdir='mkdir -pv'
mktar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }    # Creates a *.tar.gz archive of a file or folder
mkzip() { zip -r "${1%%/}.zip" "$1" ; }               # Create a *.zip archive of a file or folder

alias dockerc='docker-compose'

alias dcrestart='dockerc down; dockerc up -d && dockerc logs -ft'

export EDITOR=nano

. /usr/share/z/z.sh

mcd()
{
    mkdir -p $1
    cd $1
}

export PATH=~/.local/bin:$PATH
