# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

PATH=/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/games:/usr/games:$HOME/bin:/usr/local/opt/coreutils/libexec/gnubin

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# some colors varibles used in propmt
export COLOR_WHITE=37
export COLOR_YELLOW=33
export COLOR_GREEN=32
export COLOR_RED=31
export COLOR_BLUE=34

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
# NOT NEEDED NOW
# shopt -s checkwinsize


# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

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
	_pwd=`pwd`
	if $(which git &> /dev/null) && test -d "$_pwd/.git" ; then
		git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/' | tr -d " "
	fi
}
function parse_git_ci {
	if ! $(which git &> /dev/null); then return; fi
	if ! test -d "`pwd`/.git"; then return; fi
	if git rev-parse --git-dir &> /dev/null; then
		LONG_GIT_STATUS=`git status 2> /dev/null`
		BRANCH=$(parse_git_branch)
		if [ -z "$BRANCH" ]; then
			 BRANCH="no branch"
		fi


		if [ -n "$(echo $LONG_GIT_STATUS | egrep -ie 'nothing( added)? to commit')" ]; then
			BRANCH_COLOR=$COLOR_GREEN
		else 
			BRANCH_COLOR=$COLOR_RED
		fi
		NEED_PUSH=""
		if [ -n "$(echo $LONG_GIT_STATUS | egrep -ie 'Your branch is ahead of')" ]; then
			NEED_PUSH="\[\e[01;${COLOR_YELLOW}m\]!\[\e[0m\]"
		fi
		UNTRACKED_FILES=""
		if [ -n "$(echo $LONG_GIT_STATUS | egrep -ie 'untracked files present')" ]; then
			UNTRACKED_FILES="\[\e[00;${COLOR_WHITE}m\]*\[\e[0m\]"
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
	PR="\[\e[01;${PR_COLOR}m\]${PR}"
	echo -en "\[\e[01;${U_COLOR}m\]\u\[\e[0m\]\[\e[01;${COLOR_WHITE}m\]@\[\e[0m\]\[\e[01;${H_COLOR}m\]\h\[\e[0m\]\[\e[00;${COLOR_WHITE}m\]:\[\e[0m\]\[\e[01;${COLOR_BLUE}m\]\w\[\e[0m\]$(prompt_right)\[\e[01;${COLOR_WHITE}m\]:${PR}\[\e[0m\]\[\e[00;${COLOR_WHITE}m\]\[\e[0m\]"
}

function prompt() {
	PS1=$(printf "%s " "$(prompt_left)")
}
PROMPT_COMMAND=prompt

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

_DIRCOLORS=$(which dircolors)

if [ -x "${_DIRCOLORS}" ]; then
    test -r ~/.dircolors && eval "$($_DIRCOLORS -b ~/.dircolors)" || eval "$($_DIRCOLORS -b)"
    #alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias mtr='mtr --curses'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -f ~/.bash_autocomplete ]; then
    . ~/.bash_autocomplete
fi

export DEBFULLNAME='Lukas Drbal'
export DEBEMAIL='lukas.drbal@socialbakers.com'

# Password generator
genpasswd() {
	 local l=$1
	  [ "$l" == "" ] && l=20
	   tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}

createTmpDir () {
	local TMZ=$(date +%s)
	mkdir "tmp_$TMZ"
	cd "tmp_$TMZ"
}

tmpclone () {
	createTmpDir
	git clone $1
	cd `ls`
}

if [[ -d $HOME/.rvm ]]; then
	PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
fi

[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh # This loads NVM

httpshare () {
	python -m SimpleHTTPServer 8000
}


if $(which xsel &> /dev/null); then
	alias pbcopy='xsel -b'
fi;

export EDITOR="vim"
export SUDO_EDITOR=$EDITOR

#source fucking google API keys for chromium
if [ -f ~/.chromium.env ]; then
	. ~/.chromium.env
fi

if $(which brew &> /dev/null); then
	if [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
		. $(brew --prefix)/share/bash-completion/bash_completion
	fi
fi
