#!/bin/sh

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}"

update_counter()
{
    updates='?'
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

is_up()
{
    ip link | awk "/$1/ { if (\$9 == \"UP\") {print \"✓\"} else {print \"✗\"} }"
}

volume()
{
    icon=🔇
    test "$(pulsemixer --get-mute)" = "0" && icon=🔉

    vol="$(pulsemixer --get-volume | awk '{ if ($1 == $2) {print $1} else {print $1 ":" $2} }')"

    echo "$icon$vol%"
}

bat()
{
    # XXX Maybe time is more useful than percentage when discharging
    charge="$(acpi -b | awk '{print $4}' | tr -d ,)"

    case "$(acpi -b | awk '{print $3}')" in
        'Discharging,')
            icon=🔋
            ;;
        'Charging,')
            icon=⚡
            ;;
        'Full,')
            icon=🔌
            ;;
        *)
            icon='?'
            ;;
    esac

    echo "$icon$charge"
}

# $(mpd_statusbar)
# 🖧$(is_up enp5s0) 📶$(is_up wlp6s0) |
# $(date +'%a %d %b %R')
# echo " $(mpd_status)$(volume) | 🖧$(is_up enp5s0) 📶$(is_up wlp6s0) | $(bat) "
echo "$(update_counter)$(mic_status) $(volume) | $(bat) |"
