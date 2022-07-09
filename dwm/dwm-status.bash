#!/usr/bin/env bash

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}"
data_dir="${XDG_DATA_HOME:-$HOME/.local/share}"


function update_counter()
{
    local count

    count="$(<"$cache_dir/update_count")"
    [[ -n $count && $count != 0 ]] && echo " ↑$count |"
}


function mpd_statusbar()
{
    local -a mpc_output
    local line icon

    readarray -t mpc_output < <(mpc -f "[%title%[ – %artist%]]|[%file%]")

    icon=
    for line in "${mpc_output[@]}"
    do
        case $line in
            '[playing] '*)
                icon=♫
                ;;
            '[paused] '*)
                icon=⏸
                ;;
        esac
    done

    [[ -n $icon ]] && echo " $icon ${mpc_output[0]::35} |"
}


function unread_feeds()
{
    local unread_items

    # Reading newsboat's cache manually; `print-unread` quietly commits sudoku
    # when newsboat is already running
    unread_items="$(
        sqlite3 \
            "$data_dir/newsboat/cache.db" \
            'select count(*) from rss_item where unread=1;'
    )"
    [[ -n $unread_items && $unread_items != 0 ]] && echo " 📰$unread_items |"
}


function mic_status()
{
    local -a pa_sources mics
    local line running sink_id
    local mic_status

    readarray -t pa_sources < <(pactl list sources)

    sink_id=
    running=
    for line in "${pa_sources[@]}"
    do
        if [[ $line =~ Source\ #([0-9]*) ]]
        then
            [[ -n $sink_id ]] && mics+=("$sink_id$running")
            running=
            sink_id="${BASH_REMATCH[1]}"
        elif [[ $line = *'device.class = "monitor"' ]]
        then
            sink_id=
        elif [[ $line = *'State: RUNNING' ]]
        then
            running=!
        elif [[ $line = *'Mute: yes' ]]
        then
            sink_id=
        fi
    done

    [[ -n $sink_id ]] && mics+=("$sink_id$running")

    mic_status=
    for elem in "${mics[@]}"
    do
        if [[ -z $mic_status ]]
        then
            mic_status=" 🎤$elem"
        else
            mic_status="$mic_status;$elem"
        fi
    done

    [[ -n $mic_status ]] && echo " $mic_status |"
}



i3status | while read -r LINE
do
    echo "$(mpd_statusbar)$(update_counter)$(mic_status) $LINE"
done
