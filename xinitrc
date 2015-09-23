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

[ -f ~/.xprofile ] && . ~/.xprofile

if [ -z $1 ]; then
    gui=i3
else
    gui=$1
fi

case $gui in
    fluxbox)
        exec startfluxbox
        ;;
    gnome)
        exec gnome-session
        ;;
    i3)
        exec i3
        ;;
    kde)
        exec startkde
        ;;
    xfce)
        exec startxfce4
        ;;
    xmonad)
        ;;
esac
