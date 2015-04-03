# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

PATH=/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/games:/usr/games:$HOME/bin

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

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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
	#echo -ne "[" && git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/B:\1/'|tr -d "\n" && echo -ne "]"
	_pwd=`pwd`
	if $(which git &> /dev/null) && test -d "$_pwd/.git" ; then
		git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/' | tr -d " "
	fi
}
function parse_git_ci {
	if ! $(which git &> /dev/null); then return; fi
	if ! test -d "`pwd`/.git"; then return; fi
	if git rev-parse --git-dir &> /dev/null; then
		GIT_STATUS=`git status 2> /dev/null | tail -n1`
		BRANCH=$(parse_git_branch)
		if [ -z "$BRANCH" ]; then
			 BRANCH="(no branch)"
		fi
		if [[ "$GIT_STATUS" =~ ^nothing.* ]]; then
			BRANCH_COLOR=$COLOR_GREEN
		else 
			BRANCH_COLOR=$COLOR_RED
		fi
		NEED_PUSH=""
		#if [[ "$GIT_STATUS" =~ ahead.* ]]; then
		if [ $(echo "$GIT_STATUS" | grep -ic "Your branch is ahead of") -eq 0 ]; then
			NEED_PUSH="\e[0;${COLOR_YELLOW}m\]!"
		fi;
		echo -ne " \e[1;${COLOR_RED}m\] (\e[1;${BRANCH_COLOR}m\]${BRANCH}${NEED_PUSH}\e[1;${COLOR_RED}m\]) "
	fi
}


function prompt_right() {
	echo -e $(parse_git_ci)
	#echo -e "\033[0;37m\$(parse_git_ci)\033[0m"
	#echo -e "\e[0;37m\$(parse_git_ci)\e[0m"
}

export COLOR_WHITE=37
export COLOR_YELLOW=33
export COLOR_GREEN=32
export COLOR_RED=31
export COLOR_BLUE=34

function prompt() {
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
	
#	echo -e "\e[1;34m\]\u\e[1;37m\]@\h\[\e[00m\]:\[\e[1;34m\]\w\e[00m\]\n\[\e[1;${PR_COLOR}m\]\xe2\x88\x91\e[0;37m\]"
	echo -e "\e[1;${U_COLOR}m\]\u\e[1;${H_COLOR}m\]\e[1;${COLOR_WHITE}m\]@\e[1;${H_COLOR}m\]\h\e[${COLOR_WHITE}m\]:\e[1;${COLOR_BLUE}m\]\w$(prompt_right)\e[1;${COLOR_WHITE}m\]:=\e[1;${PR_COLOR}m\]${PR} \e[0;${COLOR_WHITE}m\]\e[00m\]"
	#echo -e "\e[01;${U_COLOR}m\]\u\e[1;32m\]@\h\[\e[00m\]:\[\e[1;34m\]\w\e[00m\]$(prompt_right) \[\e[1;${PR_COLOR}m\]\xe2\x88\x91\e[0;37m\]\e[00m\]"
}
#function prompt() {
#	P=263
#	PS1=$(printf "%s " "$(prompt_left)")
#	# "$(prompt_right)")
#	compensate=-12
#	#PS1=$(printf "%*s\r%s " "$(($(tput cols)+${compensate}))" "$(prompt_right)" "$(prompt_left)")
#	#PS1=$(printf "%s%s " "$(prompt_right)" "$(prompt_left)")
#}

#PROMPT_COMMAND=prompt

if [ "$color_prompt" = yes ]; then
	PS1=$(prompt)
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
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
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

export EDITOR=vim
export DEBFULLNAME='Lukas Drbal'
export DEBEMAIL='lukas.drbal@socialbakers.com'

# Password generator
genpasswd() {
	 local l=$1
	  [ "$l" == "" ] && l=20
	   tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}

tmp () {
	cd `_mktmp`
}

tmpclone () {
	cd `_mktmp`
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

EDITOR="vim"
SUDO_EDITOR=$EDITOR
#if $(which vimpager &> /dev/null) 
#then 
#	export PAGER="vimpager -c 'ft=man nomod nolist'"
#else
#	export PAGER="less"
#fi
#if $(which vimmanpager &> /dev/null) 
#then 
#	export MANPAGER="vimmanpager"
#else
#	export MANPAGER="col -b | vimpager -c 'set ft=man nomod nolist'"
#fi

export HERA_VERSION_PREFIX=lestr

#source fucking google API keys for chromium
if [ -f ~/.chromium.env ]; then
	. ~/.chromium.env
fi
if ! $(which brew &> /dev/null); then
	if [ -f `brew --prefix`/etc/bash_completion ]; then
		source `brew --prefix`/etc/bash_completion
	fi
fi
