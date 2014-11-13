#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# set default pointer and background
xsetroot -solid black -cursor_name left_ptr
# load .Xresources settings
xrdb -merge .Xresources
# disable annoying bell
xset b off
# set screen to standby->suspend->off after 3x300 seconds
xset dpms 300 600 900

# daemons
mpd
urxvtd -q -o -f

background_stuff() {
    # power management
    xfce4-power-manager &

    # set background
    sh ~/.fehbg
}

# read command line
if [ -z $1 ]; then
    gui=xfce
else
    gui=$1
fi

case $gui in
    fluxbox)
        background_stuff
        volumeicon &
        exec startfluxbox
        ;;
    i3)
        background_stuff
        exec i3
        ;;
    xfce)
        exec startxfce4
        ;;
    kde)
        exec startkde
        ;;
    xmonad)
        background_stuff
        exec xmonad
        ;;
esac
