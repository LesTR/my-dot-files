alias bell='echo -en "\a"'
alias cd..='cd ..'


# some more ls aliases
alias ls='ls --color=auto' 
alias ll='ls -l'
alias la='ls -Al'
alias l='ls -ahCF'

# some useful aliases
alias nocomment="grep -Ev '^($|\s*#)'"
alias se='sudo vim'
alias vim='vim'
alias vi='vim'
alias grep='grep --color=auto'

# some colorized commands
if $(which grc &> /dev/null)
then
	alias colourify="grc -es --colour=auto"
	alias ping='colourify ping'
	alias ping6='colourify ping6'
	alias make='colourify make'
	alias gcc='colourify gcc'
	alias g++='colourify g++'
fi

if $(which xsel &> /dev/null); then
	alias pbcopy='xsel -b'
fi
