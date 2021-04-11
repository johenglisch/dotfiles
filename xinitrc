#! /bin/sh

. ~/.profile

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

pidof mpd || mpd &

wm="${wm:-dwm}"
case "$wm" in
    dwm)
        apt-get -sqq --no-install-recommends dist-upgrade \
            | grep -c ^Inst \
            > "${XDG_CACHE_HOME:-$HOME/.cache}/update_count" &
        xfce4-power-manager &
        xwallpaper --zoom ~/.bg/earthrise-fhd.png --daemon &

        dunst &
        compton -b &
        dwm-status | dwm-bar &
        exec ssh-agent dwm
        ;;
    openbox)
        xfce4-power-manager &
        xwallpaper --zoom ~/.bg/earthrise-fhd.png --daemon &

        dunst &
        compton -b &
        tint2 &
        pasystray &
        exec ssh-agent openbox
        ;;
    xfce4)
        update-notification-deb &
        exec ssh-agent startxfce4
        ;;
    *)
        echo "unknown session: $wm" 1>&2
        ;;
esac
