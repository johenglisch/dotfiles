#! /bin/sh

xrdb -merge ~/.Xresources
xset b off
xset dpms 300 600 900
xsetroot -solid black -cursor_name left_ptr
xbindkeys
xwallpaper --daemon --zoom ~/.background-image
numlockx on

mpd

xfce4-power-manager &
dunst &

compton -b
exec awesome
