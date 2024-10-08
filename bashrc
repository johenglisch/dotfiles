#!/usr/bin/env bash
# ~/.bashrc

[[ $- != *i* ]] && return

if [[ $TERM = dumb ]]
then
    PS1='\W\$ '
else
    prompt_colour=32
    [[ $UID -eq 0 ]] && prompt_colour=31
    PS1="\\[\\e[0;${prompt_colour}m\\]\\W\\$\\[\\e[00m\\] "
    unset prompt_colour
fi

if [[ $TERM = xterm ]]
then
    export TERM=xterm-256color
fi

complete -cf man
complete -cf killall

# disable C-q and C-s
stty stop undef
stty start undef

# set -o vi

if [[ -f ~/.aliases ]]
then
    source ~/.aliases
fi
