#!/bin/sh

. ~/.profile

new_updates()
{
    if command -v apt-get 1>&2 >/dev/null
    then
        apt-get -ssq --no-install-recommends dist-upgrade \
            | grep ^Inst -c \
            > "${XDG_CACHE_HOME:-$HOME/.cache}/update_count"
    elif command -v pacman 1>&2 >/dev/null
    then
        pacman -Qu \
            | wc -l \
            > "${XDG_CACHE_HOME:-$HOME/.cache}/update_count"
    fi
}

#xrandr --setprovideroutputsource modesetting 1
xrandr --setprovideroffloadsink 1 0
xrandr --setprovideroutputsource 0 1
#automonitor

xrdb -merge ~/.Xresources
#setxkbmap -option grp:shifts_toggle,compose:caps de,ru nodeadkeys,ruu

xset b off
xset dpms 300 600 900
xsetroot -solid black -cursor_name left_ptr

#xbindkeys &
numlockx on

#pgrep mpd >/dev/null || mpd &
#pgrep syndaemon >/dev/null || syndaemon -d -i 0.5 -K &

# mute all mics by default
# TODO there must be a better way™
#  -> somewhere in the pulseaudio config?
#  -> somewhere in the pipewire config?
pactl list sources \
    | grep Name: \
    | cut -d' ' -f2- \
    | while read -r src_id
do
    pactl set-source-mute "$src_id" true
done
unset src_id

new_updates &
exec startxfce4
