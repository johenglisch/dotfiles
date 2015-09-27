# ~/.bashrc

[[ $- != *i* ]] && return

if [ "$TERM" = 'dumb' ]; then
    PS1="\W\$ "
else
    pclr='0;32'
    [ $UID -eq 0 ] && pclr='0;31'
    PS1="\[\e[${pclr}m\]\W\$\[\e[00m\] "
    unset pclr
fi

[ "$TERM" = 'xterm' ] && export TERM='xterm-256color'

complete -cf man
complete -cf killall

# disable C-q and C-s
stty stop undef
stty start undef

source ~/.aliases
