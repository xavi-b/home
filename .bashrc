USERCOLOR="\[\033[38;5;4m\]"
ROOTCOLOR="\[\033[31m\]"
HOSTCOLOR="\[\033[38;5;226m\]"
DIRCOLOR="\[\033[32m\]"
WHITECOLOR="\[\033[00m\]"
TIMECOLOR="\[\033[38;5;208m\]"
GITCOLOR="\[\033[38;5;136m\]"
ROOTDIRCOLOR="\[\033[38;5;196m\]"
ROOTGITCOLOR="\[\033[38;5;168m\]"

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

parse_git_branch()
{
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

parse_git_status()
{
	git status -s 2> /dev/null | wc -l
}

# directory
if [[ ${EUID} == 0 ]] ; then
    PS1+="$ROOTDIRCOLOR"
else
	PS1+="$DIRCOLOR"
fi
    
PS1+="$BOLD\w"

if [[ ${EUID} == 0 ]] ; then
	PS1+="$ROOTGITCOLOR"
else
	PS1+="$GITCOLOR"
fi

GITBRANCH='$(parse_git_branch)'

PS1+="$GITBRANCH"

#if [ "$GITBRANCH" != 0 ] ; then
#	PS1+="$ROOTDIRCOLOR "
#	PS1+='[$(parse_git_status)]'
#fi

PS1+="$NORMAL$WHITECOLOR\n▶▶ "

export PS1

PS2=">>"

export PS2

alias ls='ls --color'
alias grep='grep --color'
alias ll='ls -la'
alias cp='cp -i'

alias lld='ll -h'
alias mkdir='mkdir -pv'
mktar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }    # Creates a *.tar.gz archive of a file or folder
mkzip() { zip -r "${1%%/}.zip" "$1" ; }               # Create a *.zip archive of a file or folder

alias dockerc='docker-compose'
