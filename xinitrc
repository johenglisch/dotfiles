#! /bin/sh

. ~/.profile

xrandr --setprovideroutputsource modesetting NVIDIA-0
automonitor

xrdb -merge ~/.Xresources

xset b off
xset dpms 300 600 900
xsetroot -solid black -cursor_name left_ptr

xbindkeys &
numlockx on

GTK_IM_MODULE=uim
QT_IM_MODULE=uim
export GTK_IM_MODULE QT_IM_MODULE
uim-xim &

XMODIFIERS=@im=uim
export XMODIFIERS

mpd &

wm=dwm
case "$wm" in
    dwm)
        update-notification-dwm &
        xfce4-power-manager &
        xwallpaper --zoom ~/.bg/earthrise-fhd.png --daemon &

        uim-toolbar-gtk3 &

        dunst &
        compton -b &
        dwm-status | dwm-bar &
        exec dwm
        ;;
    xfce4)
        update-notification-deb &
        uim-toolbar-gtk3-systray &
        exec startxfce4
        ;;
    *)
        echo "unknown session: $wm" 1>&2
        ;;
esac
