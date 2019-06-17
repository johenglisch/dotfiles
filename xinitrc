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

export GTK_IM_MODULE=uim
export QT_IM_MODULE=uim
uim-xim &
export XMODIFIERS=@im=uim

update-notification &

case "${wm:-xfce4}" in
    dwm)
        xfce4-power-manager &
        dunst &
        xwallpaper --zoom ~/.background-image --daemon &
        uim-toolbar-gtk3 &
        dwm-status &
        exec dwm
        ;;
    fluxbox)
        xfce4-power-manager &
        dunst &
        xwallpaper --zoom ~/.background-image --daemon &
        uim-toolbar-gtk3-systray &
        pasystray &
        exec fluxbox
        ;;
    xfce4)
        uim-toolbar-gtk3 &
        exec startxfce4
        ;;
    *)
        echo "unknown session: $wm" 1>&2
        ;;
esac
