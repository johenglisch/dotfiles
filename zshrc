# ~/.zshrc

if [ "$TERM" = dumb ]
then
    prompt="%1~%# "
else
    promptclr=green
    [ $UID -eq 0 ] && promptclr=red
    prompt="%{%F{$promptclr}%}%1~%#%{%f%} "
    unset $promptclr
fi

[ "$TERM" = xterm ] && export TERM=xterm-256color

autoload -U promptinit && promptinit
autoload -U compinit && compinit
autoload -U colors && colors
autoload -U edit-command-line
zle -N edit-command-line

bindkey -v
bindkey '\C-g' vi-cmd-mode
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward
bindkey -M vicmd '\e[A' history-search-backward
bindkey -M vicmd '\e[B' history-search-forward
bindkey -M vicmd k history-search-backward
bindkey -M vicmd j history-search-forward

bindkey -M vicmd v edit-command-line

# disable C-q and C-s
stty stop undef
stty start undef

HISTFILE="$HOME/.histfile"
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

setopt nobeep

source ~/.aliases
