# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/games:/usr/games:$HOME/bin

#Use gnu tools from homebrew
if $(which brew &> /dev/null); then
  BREW_PREFIX=$(brew --prefix)
  PATH="${BREW_PREFIX}/opt/coreutils/libexec/gnubin:${PATH}"
  PATH="${BREW_PREFIX}/opt/gnu-sed/libexec/gnubin:${PATH}"
  PATH="${BREW_PREFIX}/opt/make/libexec/gnubin/:${PATH}"
  PATH="${BREW_PREFIX}/opt/findutils/libexec/gnubin/:${PATH}"
  PATH="${BREW_PREFIX}/opt/grep/libexec/gnubin/:${PATH}"
  PATH="${BREW_PREFIX}/opt/binutils/bin:$PATH"
  PATH="${BREW_PREFIX}/opt/gawk/libexec/gnubin:$PATH"
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return
if [ -f ~/.bash_colors ]; then
    source ~/.bash_colors
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

export LC_CTYPE="en_US.UTF-8"
export DEBFULLNAME='Lukas Drbal'
export DEBEMAIL='lukas.drbal@gmail.com'
export EDITOR="vim"
export SUDO_EDITOR=$EDITOR
export GPG_TTY=$(tty)

# Stupid ansible developers
export ANSIBLE_NOCOWS=1

# Gcloud python settings
export CLOUDSDK_PYTHON=python3


# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-256color) color_prompt=yes;;
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/' | tr -d " "
}
function parse_git_ci {
    if ! $(which git &> /dev/null); then return; fi
    if git rev-parse --is-inside-work-tree &> /dev/null; then
        LONG_GIT_STATUS=`git status 2> /dev/null`
        BRANCH=$(parse_git_branch)
        if [ -z "$BRANCH" ]; then
            BRANCH="no branch"
        fi

        #for git-flow prefixes i want just first character
        local gitFlowBranchPrefixes=(feature bugfix hotfix release)
        if [[ "${gitFlowBranchPrefixes[@]}" =~ $(echo $BRANCH | cut -d "/" -f 1) ]]; then
            local pre=$(echo ${BRANCH:0:1}|awk '{print toupper($0)}')
            local issue=$(echo $BRANCH | cut -d "/" -f 2)
            BRANCH="${pre}/${issue}"
        fi
        if [ -n "$(echo $LONG_GIT_STATUS | ggrep -iE  'nothing( added)? to commit')" ]; then
            BRANCH_COLOR=$COLOR_GREEN
        else
            BRANCH_COLOR=$COLOR_RED
        fi
        NEED_PUSH=""
        if [ -n "$(echo $LONG_GIT_STATUS | ggrep -iE 'Your branch is ahead of')" ]; then
            NEED_PUSH="\[\e[01;${COLOR_YELLOW}m\]!\[\e[0m\]"
        fi
        UNTRACKED_FILES=""
        if [ -n "$(echo $LONG_GIT_STATUS | ggrep -iE 'Untracked files:')" ]; then
            UNTRACKED_FILES="\[\e[00;${COLOR_RED}m\]?\[\e[0m\]"
        fi;
        echo -ne "(\[\e[01;${BRANCH_COLOR}m\]${BRANCH}${NEED_PUSH}${UNTRACKED_FILES}\[\e[0m\]\[\e[00;${COLOR_WHITE}m\]\[\e[0m\])"
    fi
}


function prompt_right() {
    echo -e $(parse_git_ci)
}


function prompt_left() {
    if [ "${TERM}" == "screen" ]; then
        PR_COLOR=$COLOR_YELLOW
    else
        PR_COLOR=$COLOR_RED
    fi
    if [ "$UID" -eq 0 ]; then
        U_COLOR=$COLOR_RED
        H_COLOR=$COLOR_YELLOW
        PR="<|>"
    else
        U_COLOR=$COLOR_YELLOW
        H_COLOR=$COLOR_GREEN
        PR="\xe2\x88\x91"
    fi
    local host='localhost'
    if [ -n "$SSH_CLIENT" ]; then
        H_COLOR=$COLOR_RED
        host="\h"
    fi

    PR="\[\e[01;${PR_COLOR}m\]${PR}"
    echo -en "\[\e[01;${U_COLOR}m\]\u\[\e[0m\]\[\e[01;${COLOR_WHITE}m\]@\[\e[0m\]\[\e[01;${H_COLOR}m\]${host}\[\e[0m\]\[\e[00;${COLOR_WHITE}m\]:\[\e[0m\]\[\e[01;${COLOR_BLUE}m\]\w\[\e[0m\]$(prompt_right)\[\e[01;${COLOR_WHITE}m\]:${PR}\[\e[0m\]\[\e[00;${COLOR_WHITE}m\]\[\e[0m\]"
}

function prompt() {
    PS1=$(printf "%s " "$(prompt_left)")
}
PROMPT_COMMAND=prompt
PROMPT_DIRTRIM=3

if [ "$color_prompt" = yes ]; then
    PS1X=$(prompt)
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x "$(which dircolors &> /dev/null)" ]; then
    test -r ~/.dircolors && eval "$($_DIRCOLORS -b ~/.dircolors)" || eval "$($_DIRCOLORS -b)"
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

if [ -f ~/.shell_aliases ]; then
	source ~/.shell_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    source /etc/bash_completion
#fi
# file for custom bash completition
if [ -f ~/.bash_autocomplete ]; then
    source ~/.bash_autocomplete
fi
# custom bash functions
if [ -f ~/.bash_functions ]; then
    source  ~/.bash_functions
fi
# i hate ruby!
[ -d "$HOME/.rvm" ] && PATH=$HOME/.rvm/bin:$PATH # Add RVM to PATH for scripting

#if [ -f "/usr/local/opt/nvm/nvm.sh" ]; then
#    export NVM_DIR="$HOME/.nvm"
#    [ -s "/usr/local/opt/nvm/nvm.sh" ] && source "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
#    [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && source "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion
#fi

#source fucking google API keys for chromium
[ -f ~/.chromium.env ] && source ~/.chromium.env

#Forward ssh-agent into screen
if [[ -S "$SSH_AUTH_SOCK" && ! -h "$SSH_AUTH_SOCK" ]]; then
    if [ ! -d ~/.ssh ]; then
        mkdir ~/.ssh
    fi
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
if [ -n "$SSH_AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
fi
