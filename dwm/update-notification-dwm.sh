#!/bin/sh

apt-get --no-install-recommends dist-upgrade -sqq \
    | grep -ce ^Inst \
    > "${XDG_CACHE_HOME-$HOME/.cache}/update_count"
