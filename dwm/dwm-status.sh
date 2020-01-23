#!/bin/sh


update_counter()
{
    updates=?
    test -f ~/.cache/update_count && updates="$(cat ~/.cache/update_count)"
    echo "$updates"
}


mpd_statusbar()
{
    mpd_output="$(mpc -f "[%title%[ – %artist%]]|[%file%]")"

    mpd_status="$(echo "$mpd_output" | awk '/^\[/ {print $1}')"
    test -z "$mpd_status" && return

    mpd_icon=⏸
    test "$mpd_status" = "[playing]" && mpd_icon=♫

    mpd_song="$(echo "$mpd_output" | head -n1 | cut -c1-35 | iconv -c)"

    echo " $mpd_icon $mpd_song |"
}


i3status | while read -r LINE
do
    echo "$(mpd_statusbar) ↑$(update_counter) | $LINE"
done
