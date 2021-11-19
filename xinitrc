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

xset b off
xset dpms 300 600 900
xsetroot -solid black -cursor_name left_ptr

xbindkeys &
numlockx on

pgrep mpd >/dev/null || mpd &
pgrep syndaemon >/dev/null || syndaemon -d -i 0.5 -K &

wm="${wm:-floating}"
case "$wm" in
    dwm)
        new_updates &
        xfce4-power-manager &
        sh ~/.fehbg

        dunst &
        picom -cC --backend glx --vsync -b &
        dwm-status | dwm-bar &
        exec ssh-agent dwm
        ;;
    floating)
        new_updates &
        xfce4-power-manager &
        sh ~/.fehbg
        xscreensaver -no-splash &

        conky -d &

        dunst &
        picom -cC --backend glx --vsync -b &
        #pasystray &
        exec ssh-agent startfluxbox
        #exec ssh-agent awesome
        ;;
    openbox)
        xfce4-power-manager &
        sh ~/.fehbg

        dunst &
        picom -cC --backend glx --vsync -b &
        tint2 &
        pasystray &
        exec ssh-agent openbox
        ;;
    xfce4)
        new_updates &
        exec ssh-agent startxfce4
        ;;
    kde)
        DESKTOP_SESSION=plasma
        export DESKTOP_SESSION
        exec startplasma-x11
        ;;
    *)
        echo "unknown session: $wm" 1>&2
        ;;
esac
