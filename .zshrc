# enable completion
autoload -U compinit && compinit

# enable colours
autoload -U colors && colors
alias ls='ls -h --color=auto'
alias grep='grep --color=auto'
man() {
    env LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
}

# prompt
promptclr="green"
[ "$UID" -eq "0" ] && promptclr='red'
prompt="%{%F{$promptclr}%}%1~%#%{%f%} "
unset $promptclr
autoload -U promptinit && promptinit

# variables
EDITOR="/usr/bin/vim -p"

# key bindings
bindkey -v
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward
bindkey -M vicmd '\e[A' history-search-backward
bindkey -M vicmd '\e[B' history-search-forward
bindkey -M vicmd k history-search-backward
bindkey -M vicmd j history-search-forward

# history settings
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

# aliases
alias ..='cd ..'
alias la='ls -AlF'
alias huhu='echo -e "\a"'
alias mkdir='mkdir -p'
