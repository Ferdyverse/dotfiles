#!/usr/bin/env bash

# Fetch available networks
networks=$(nmcli -t -f SSID,SECURITY dev wifi | awk -F: '{ if ($1 != "") print $1 " (" $2 ")"}')

# Show networks in RoFi
chosen_network=$(echo -e "$networks" | rofi -dmenu -p "Select Wi-Fi Network:")

# Exit if no network was selected
[ -z "$chosen_network" ] && exit 1

# Extract SSID
ssid=$(echo "$chosen_network" | sed 's/ (.*)//')

# Prompt for password if network is secured
security=$(nmcli -t -f SSID,SECURITY dev wifi | grep "^$ssid:" | cut -d':' -f2)
if [[ "$security" != "--" ]]; then
    password=$(rofi -dmenu -theme $HOME/.config/rofi/wireguard.rasi -password -p "Enter Password for $ssid:")
    [ -z "$password" ] && exit 1
fi

# Connect to the selected network
if [[ "$security" != "--" ]]; then
    nmcli dev wifi connect "$ssid" password "$password"
else
    nmcli dev wifi connect "$ssid"
fi

# Notify user of success or failure
if [ $? -eq 0 ]; then
    notify-send "Wi-Fi" "Connected to $ssid successfully"
else
    notify-send "Wi-Fi" "Failed to connect to $ssid"
fi
