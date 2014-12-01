#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# prompt
pclr='01;32'
[ $UID -eq 0 ] && pclr='01;31'
PS1="\[\e[${pclr}m\]\W\$\[\e[00m\] "
unset pclr

# colours
alias ls='ls -h --color=auto'
alias grep='grep --color=auto'
#alias packer='packer-color'
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

# aliases
alias ..='cd ..'
alias la='ls -A'
alias ll='ls -AlF'
alias huhu='echo -e "\a"'
alias mkdir='mkdir -p'
# alias ed='ed -p"*"'
alias emacs='emacs -nw'

# shortcut for wpa supplicant
alias wpa_wifi='wpa_supplicant -BDwext -iwifi -c'

# completion
complete -cf man
complete -cf killall

# disable C-q and C-s
stty stop undef
stty start undef

# vi stuffz
set -o vi
alias :q='exit'
