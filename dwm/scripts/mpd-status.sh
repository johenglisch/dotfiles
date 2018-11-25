#! /bin/bash
set -euo pipefail

mpc_output="$(mpc -f "[%title%[ – %artist%]]|[%file%]")"

status="$(echo "$mpc_output" | grep -e '^\[' | awk '{print $1}')"
test -z "$status" && exit

icon="⏸"
test "$status" = "[playing]" && icon="♫"

current_song="$(echo "$mpc_output" | head -n1 | cut -c1-35)"

echo "${icon} ${current_song} | "
