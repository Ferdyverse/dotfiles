#!/bin/bash
# Restart waybar when its configuration files change

CONFIG_DIR="$HOME/.config/waybar"

while true; do
    logger -i "$0: Monitoring changes in $CONFIG_DIR..."
    # Monitor the directory for changes
    inotifywait -e modify -e move -e create -e delete --recursive "$CONFIG_DIR" 2>&1 | logger -i
    if [ $? -eq 0 ]; then
        logger -i "$0: Configuration change detected. Sending SIGUSR2 to waybar..."
        killall -SIGUSR2 waybar &&
            logger -i "$0: Successfully reloaded waybar." ||
            logger -i "$0: Failed to reload waybar. Check if the process is running."
    else
        logger -i "$0: Error detected in inotifywait. Exiting loop."
        exit 1
    fi
done

# You can monitor changes via
# sudo journalctl | grep auto_reload_waybar.sh
