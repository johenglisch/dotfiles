#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# prompt
pclr='01;32'
[ "$UID" -eq "0" ] && pclr='01;31'
PS1="\[\e[${pclr}m\]\W\$\[\e[00m\] "
unset pclr

# aliases
alias la='ls -AlF'
alias ..='cd ..'
alias huhu='echo -e "\a"'
alias mkdir='mkdir -p'

# disable C-q, C-s
stty stop undef
stty start undef

# vi-ify prompt
set -o vi
alias :q='exit'
