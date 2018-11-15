#! /bin/bash

xrdb -merge ~/.Xresources
xset b off
xset dpms 300 600 900
xsetroot -solid black -cursor_name left_ptr
numlockx on
xbindkeys

mpd

xfce4-power-manager &
nm-applet &
dunst &

sh ~/.fehbg

bash ~/.dwm/statusbar.bash &

exec dwm
