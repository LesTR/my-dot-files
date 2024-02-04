alias bell='echo -en "\a"'
alias cd..='cd ..'
alias ..='cd ..'

alias mc="mc --nosubshell"

# some more ls aliases
alias ls='ls --color=auto'
alias ll='ls -lh'
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

alias ducks='du -cks * | sort -rn'
alias brew-upgrade='brew update && brew upgrade && brew cleanup'

if $(which xsel &> /dev/null); then
    alias pbcopy='xsel -b'
fi

if ! $(which jshon &> /dev/null); then
    alias jshon='myjshon'
else
    unalias jshon &>/dev/null
fi

if [[ $OSTYPE == darwin* ]]; then
    alias flushdns='dscacheutil -flushcache'
fi

alias kube='kubectl'
alias k='kubectl'
alias kctx='kubectx'

# completion for aliases (use `complete -p command` to resolve completition for command)
complete -o default -F __start_kubectl kube
complete -o default -F __start_kubectl k
#complete -o default -o nospace -F __start_kubectl k
complete -o default -F _kube_contexts kctx
