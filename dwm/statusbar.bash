#! /bin/bash

i3status | while read LINE
do
    test -z "$(pgrep dwm)" && exit
    cursong="$(bash ~/.dwm/scripts/mpd-status.sh)"
    xsetroot -name "${cursong}${LINE}"
done
