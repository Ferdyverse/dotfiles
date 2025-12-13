#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $current_dir/utils.sh

socket="${XDG_RUNTIME_DIR:-/run/user/$UID}/yubikey-touch-detector.socket"

get_yubikey_status() {
  if [ ! -f "$socket" ]; then
    echo ''
  else
    # check if any touches are active
    count=0
    exec 3<> <(nc -U "$socket")
    printf 'STAT' >&3
    read -n5 cmd <&3
    exec 3>&-
    if [ "${cmd:4:1}" = "1" ]; then
      echo '🔑'
    else
      echo ''
    fi
  fi
}

main() {
  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
  yubikey_status=$(get_yubikey_status)
  echo "$yubikey_status"
  sleep $RATE
}

main
