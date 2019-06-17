#! /bin/sh

mpd_status()
{
    local mpc_output
    mpc_output="$(mpc -f "[%title%[ – %artist%]]|[%file%]")"

    local status
    status="$(echo "$mpc_output" | awk '/^\[/ {print $1}')"
    test -z "$status" && return

    local icon
    icon=⏸
    test "$status" = "[playing]" && icon=♫

    local current_song
    current_song="$(echo "$mpc_output" | head -n1 | cut -c1-35)"

    echo "${icon} ${current_song} | "
}

is_up()
{
    ip link | awk "/$1/ { if (\$9 == \"UP\") {print \"✓\"} else {print \"✗\"} }"
}

volume()
{
    local icon
    icon=🔇
    test "$(pulsemixer --get-mute)" = "0" && icon=🔉

    local vol
    vol="$(pulsemixer --get-volume | awk '{ if ($1 == $2) {print $1} else {print $1 ":" $2} }')"

    echo "$icon$vol%"
}

bat()
{
    # XXX Maybe time is more useful than percentage when discharging
    local charge
    charge="$(acpi -b | awk '{print $4}' | tr -d ,)"

    local icon
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

echo " $(mpd_status)$(volume) | 🖧$(is_up enp4s0) 📶$(is_up wlp5s0) | $(bat) | $(date +'%a %d %b %R') "
