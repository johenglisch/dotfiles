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
automonitor

xrdb -merge ~/.Xresources
setxkbmap -option grp:shifts_toggle,compose:caps de,ru nodeadkeys,ruu

xset b off
xset dpms 300 600 900
xsetroot -solid black -cursor_name left_ptr

xbindkeys &
numlockx on

pgrep mpd >/dev/null || mpd &
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

wm="${wm:-plasma}"
case "$wm" in
    tiling)
        new_updates &
        xfce4-power-manager &
        sh ~/.fehbg
        dunst &
        picom -bc \
            --unredir-if-possible --xinerama-shadow-crop \
            --backend glx --glx-no-stencil --glx-no-rebind-pixmap \
            --shadow-exclude 'class_i = "dwm"' \
            --shadow-exclude 'class_i = "i3-frame"' \
            --shadow-exclude 'class_g = "i3-bar"' \
            --shadow-exclude 'class_g = "_HERBST_FRAME"'
        lxpolkit &
        (dwm-status | dwm-bar) &
        exec ssh-agent dwm
        ;;
    fluxbox)
        new_updates &
        xfce4-power-manager &
        sh ~/.fehbg

        wmtime &
        wmcore &
        wmnd -I enp5s0 &
        wmnd -I wlp6s0 &
        wmupdates ~/.cache/update_count &

        dunst &
        nm-applet &
        picom -bc \
            --unredir-if-possible --xinerama-shadow-crop \
            --backend glx --glx-no-stencil --glx-no-rebind-pixmap
        pasystray &
        lxpolkit &
        exec ssh-agent startfluxbox
        ;;
    xfce4)
        new_updates &
        exec ssh-agent startxfce4
        ;;
    plasma)
        DESKTOP_SESSION=plasma
        export DESKTOP_SESSION
        exec startplasma-x11
        ;;
    *)
        echo "unknown session: $wm" 1>&2
        ;;
esac
