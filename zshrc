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

# case-insensitive completion
# XXX: only for ascii?
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# dear zsh,
# please dont randomly enable vi mode just because i set my $EDITOR to vim
# cheers (^^)/
bindkey -e

# disable C-q and C-s
stty stop undef
stty start undef

HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

unsetopt nomatch
setopt nobeep

source ~/.aliases
