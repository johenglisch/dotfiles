# ~/.bashrc

[[ $- != *i* ]] && return

pclr='01;32'
[ $UID -eq 0 ] && pclr='01;31'
PS1="\[\e[${pclr}m\]\W\$\[\e[00m\] "
unset pclr

set -o vi

complete -cf man
complete -cf killall

# disable C-q and C-s
stty stop undef
stty start undef

source .aliases
