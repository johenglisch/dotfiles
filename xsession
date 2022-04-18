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

wm="${wm:-fluxbox}"
case "$wm" in
    dwm)
        new_updates &
        xfce4-power-manager &
        sh ~/.fehbg

        dunst &
        picom -bc \
            --unredir-if-possible --xinerama-shadow-crop \
            --backend glx --glx-no-stencil --glx-no-rebind-pixmap
        dwm-status | dwm-bar &
        exec ssh-agent dwm
        ;;
    awesome)
        new_updates &
        xfce4-power-manager &
        sh ~/.fehbg

        #conky -d &
        dunst &
        picom -bc \
            --unredir-if-possible --xinerama-shadow-crop \
            --backend glx --glx-no-stencil --glx-no-rebind-pixmap
        exec ssh-agent awesome
        #pasystray &
        #exec ssh-agent startfluxbox
        ;;
    fluxbox)
        xfce4-power-manager &
        sh ~/.fehbg

        #conky -d &
        dunst &
        picom -bc \
            --unredir-if-possible --xinerama-shadow-crop \
            --backend glx --glx-no-stencil --glx-no-rebind-pixmap
        pasystray &
        exec ssh-agent startfluxbox
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
