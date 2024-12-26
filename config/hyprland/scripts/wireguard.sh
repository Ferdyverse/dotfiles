#!/usr/bin/env bash

SERVICE_NAME="wg-quick@wgmate"
STATUS_CONNECTED_STR='{"text":"Connected","class":"connected","alt":"connected"}'
STATUS_DISCONNECTED_STR='{"text":"Disconnected","class":"disconnected","alt":"disconnected"}'

function askpass() {
  rofi -dmenu -theme $HOME/.config/rofi/wireguard.rasi -password -p "Enter sudo password: "
}

function status_wireguard() {
  systemctl is-active $SERVICE_NAME >/dev/null 2>&1
  return $?
}

function toggle_wireguard() {
  if [status_wireguard -eq 0]; then
    SUDO_ASKPASS=~/.config/hypr/scripts/wireguard.sh sudo -A systemctl stop $SERVICE_NAME && notify-send -e -u low "WireGuard disabled!"
  else
    SUDO_ASKPASS=~/.config/hypr/scripts/wireguard.sh sudo -A systemctl start $SERVICE_NAME && notify-send -e -u low "WireGuard enabled!"
  fi
}

case $1 in
-s | --status)
  status_wireguard && echo $STATUS_CONNECTED_STR || echo $STATUS_DISCONNECTED_STR
  ;;
-t | --toggle)
  toggle_wireguard
  ;;
*)
  askpass
  ;;
esac
