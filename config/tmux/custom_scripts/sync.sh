#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

label=$1

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

get_synchronize_panes_status() {
    current_synchronize_panes_status=$(get_tmux_window_option "synchronize-panes" "off")
    if [ "$current_synchronize_panes_status" = "on" ]; then
        # Use printf for better UTF-8 handling
        current_synchronize_panes_status=$(printf '\uf456 Synced')
    else
        current_synchronize_panes_status=""
    fi
    echo "$current_synchronize_panes_status"
}

main()
{
    RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
    synchronize_panes_status=$(get_synchronize_panes_status)
    echo "$synchronize_panes_status"
    sleep $RATE
}

main
