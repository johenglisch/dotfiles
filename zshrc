#!/usr/bin/env zsh
# ~/.zshrc

if [[ $TERM = dumb ]]
then
    prompt="%1~%# "
    unset zle_bracketed_paste
else
    promptclr=green
    [[ $UID -eq 0 ]] && promptclr=red
    prompt="%{%F{$promptclr}%}%1~%#%{%f%} "
    unset $promptclr
fi

if [[ $TERM = xterm ]]
then
    export TERM=xterm-256color
fi

autoload -U promptinit && promptinit
autoload -U compinit && compinit
autoload -U colors && colors

# case-insensitive completion
# XXX: only for ascii?
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# dear zsh,
# please dont randomly enable vi mode just because i set my $EDITOR to vim
# cheers (^^)/
bindkey -e

# emacs' word-wise movement moves waaaay to far
bindkey -M emacs "^[b" vi-backward-word
bindkey -M emacs "^[B" vi-backward-word
bindkey -M emacs "^[f" vi-forward-word
bindkey -M emacs "^[F" vi-forward-word

# disable C-q and C-s
stty stop undef
stty start undef

DISABLE_AUTO_TITLE=true

HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000
setopt appendhistory

unsetopt nomatch
setopt nobeep

if [[ -f ~/.aliases ]]
then
    source ~/.aliases
fi
