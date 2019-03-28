#!/bin/bash

WHITECOLOR="\e[39m"
REDCOLOR="\e[91m"
BLUECOLOR="\e[94m"
GREENCOLOR="\e[92m"

GITCOLOR="\033[38;5;136m"

if [[ ${EUID} == 0 ]] ; then
    GITCOLOR="\033[38;5;168m"
fi

getGitCounts()
{
    local AHEADCOUNT=""
    local BEHINDCOUNT=""

    local LOCALBRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    if [[ -n "$LOCALBRANCH" ]] && [[ "$LOCALBRANCH" != "HEAD" ]]; then
        local UPSTREAMBRANCH=$(git rev-parse --abbrev-ref "@{upstream}" 2> /dev/null)

        if [[ "$UPSTREAMBRANCH" = "@{upstream}" ]]; then
            UPSTREAMBRANCH=""
        fi

        if [[ -z "$UPSTREAMBRANCH" ]]; then
            UPSTREAMBRANCH="origin/$LOCALBRANCH"
        fi

        if [[ -n "$UPSTREAMBRANCH" ]]; then
            AHEADCOUNT=$(git rev-list --left-right ${LOCALBRANCH}...${UPSTREAMBRANCH} 2> /dev/null | grep -s -c '^<')
            BEHINDCOUNT=$(git rev-list --left-right ${LOCALBRANCH}...${UPSTREAMBRANCH} 2> /dev/null | grep -s -c '^>')
            if [[ "$AHEADCOUNT" = 0 ]]; then
                AHEADCOUNT=""
            else
                AHEADCOUNT="$WHITECOLOR↑$AHEADCOUNT"
            fi
            if [[ "$BEHINDCOUNT" = 0 ]]; then
                BEHINDCOUNT=""
            else
                BEHINDCOUNT="$WHITECOLOR↓$BEHINDCOUNT"
            fi
        fi
    fi

    local STATUS=$(git status --porcelain -uall 2> /dev/null)

    local DIRTYCOUNT=$(echo "$STATUS" | grep -s -c '^[ADU][ADU].')
    if [[ "$DIRTYCOUNT" = 0 ]]; then
        DIRTYCOUNT=""
    else
        DIRTYCOUNT="$REDCOLOR◍$DIRTYCOUNT"
    fi

    local UNTRACKEDCOUNT=$(echo "$STATUS" | grep -s -c '^??')
    if [[ "$UNTRACKEDCOUNT" = 0 ]]; then
        UNTRACKEDCOUNT=""
    else
        UNTRACKEDCOUNT="$WHITECOLOR◌$UNTRACKEDCOUNT"
    fi

    local STAGEDCOUNT=$(echo "$STATUS" | grep -s -c '^[AMDR]')
    if [[ "$STAGEDCOUNT" = 0 ]]; then
        STAGEDCOUNT=""
    else
        STAGEDCOUNT="$GREENCOLOR◉$STAGEDCOUNT"
    fi

    local UNSTAGEDCOUNT=$(echo "$STATUS" | grep -s -c '^[ AMDR][AMDR]')
    if [[ "$UNSTAGEDCOUNT" = 0 ]]; then
        UNSTAGEDCOUNT=""
    else
        UNSTAGEDCOUNT="$BLUECOLOR◯$UNSTAGEDCOUNT"
    fi

    local RESULT="$AHEADCOUNT$BEHINDCOUNT$STAGEDCOUNT$DIRTYCOUNT$UNSTAGEDCOUNT$UNTRACKEDCOUNT"
    if ! [[ -z RESULT ]]; then
        RESULT="$WHITECOLOR|$RESULT"
    fi

    echo "$RESULT"
}

getGitStatus()
{
    local BRANCH=""

    if BRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
        local UPSTREAM=""
        local ISBRANCH=""
        local STATE=""
        local GITDIR="$(git rev-parse --show-toplevel)/.git"

        if [[ "$BRANCH" == "HEAD" ]]; then
            BRANCH=$(git name-rev --tags --name-only $(git rev-parse HEAD))
            if ! [[ $BRANCH == *"~"* || $BRANCH == *" "* || $BRANCH == undefined ]]; then
                BRANCH="+${BRANCH}"
            else
                BRANCH='#'$(git rev-parse --short HEAD 2> /dev/null)
            fi
        else
            UPSTREAM=$(git rev-parse '@{upstream}' 2> /dev/null)
            ISBRANCH=true
        fi

        if [[ -d "$GITDIR/rebase-merge" ]] || [[ -d "$GITDIR/rebase-apply" ]]; then
            STATE=REBASE
        elif [[ -f "$GITDIR/MERGE_HEAD" ]]; then
            STATE=MERGE
        elif [[ -f "$GITDIR/CHERRY_PICK_HEAD" ]]; then
            STATE=CHERRY-PICK
        elif [[ -f "$GITDIR/REVERT_HEAD" ]]; then
            STATE=REVERT
        elif [[ -f "$GITDIR/BISECT_LOG" ]]; then
            STATE=BISECT
        fi

        local GITBRANCH="$GITCOLOR"
        if [[ -n "$STATE" ]]; then
            GITBRANCH+="{$BRANCH|$STATE"
            GITBRANCH+=$(getGitCounts)
            GITBRANCH+="$GITCOLOR"
            GITBRANCH+="}"
        elif [[ -n "$ISBRANCH" && -n "$UPSTREAM" ]]; then
            # BRANCH has an upstream
            GITBRANCH+="($BRANCH"
            GITBRANCH+=$(getGitCounts)
            GITBRANCH+="$GITCOLOR"
            GITBRANCH+=")"
        elif [[ -n "$ISBRANCH" ]]; then
            # BRANCH has no upstream
            GITBRANCH+="[$BRANCH"
            GITBRANCH+=$(getGitCounts)
            GITBRANCH+="$GITCOLOR"
            GITBRANCH+="]"
        else
            # BRANCH detached
            GITBRANCH+="(:$BRANCH"
            GITBRANCH+=$(getGitCounts)
            GITBRANCH+="$GITCOLOR"
            GITBRANCH+=")"
        fi
    else
        GITBRANCH=""
    fi

    echo -e $GITBRANCH
}
