#!/bin/sh

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}"

update_counter()
{
    updates=?
    test -f "$cache_dir/update_count" && updates="$(cat "$cache_dir/update_count")"
    [ -n "$updates" ] && [ "$updates" != 0 ] && echo " ↑$updates |"
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


newsboat_print_unread()
{
    # Reading newsboat's cache manually; `print-unread` quietly commits sudoku
    # when newsboat is already running
    sqlite3 \
        "${XDG_DATA_HOME:-$HOME/.local/share}/newsboat/cache.db" \
        'select count(*) from rss_item where unread=1;'
}


unread_feeds()
{
    unread_items="$(newsboat_print_unread)"
    if [ -n "$unread_items" ] && [ "$unread_items" != 0 ]
    then
        echo " 📰$unread_items |"
    fi
}


old_mic_status()
{
    amixer get Capture \
        | grep -q 'Capture.*\[on\]' \
        && echo ' 🎤 |'
}

less_old_mic_status()
{
    pactl list short sources \
        | grep -q 'RUNNING$' \
        && echo ' 🎤 |'
}


# FIXME this is jank af
awk_program()
{
    cat <<EOF
function print_sink(sink)
{
    if (sink)
    {
        if (running) { r="!" } else { r="" }
        print " 🎤" sink r
    }
}
BEGIN { ORS=" " ; sink="" ; running=0 }
/^Source/ { if (sink) { print_sink(sink) } ; sink=\$2 ; running=0 }
/device.class = "monitor"/ { sink="" }
/State: RUNNING/ { running=1 }
/Mute: yes/ { sink="" }
END { if (sink) { print_sink(sink) ; print "|" } }
EOF
}

mic_status()
{
    # XXX there must be a better way™ (<_<)"
    pactl list sources | awk "$(awk_program)"
}


i3status | while read -r LINE
do
    echo "$(mpd_statusbar)$(update_counter)$(mic_status) $LINE"
done
