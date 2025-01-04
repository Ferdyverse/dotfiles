#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Change to the directory where the script is located
SCRIPT_DIR="$HOME/.dotfiles"

cd "$SCRIPT_DIR" || {
    echo "Failed to change directory to $SCRIPT_DIR"
    exit 1
}

for function_script in "$SCRIPT_DIR"/functions/*.sh; do
    source "$function_script"
done

# Determine distribution and environment
DISTRO=$(source /etc/os-release 2>/dev/null && echo $ID || {
    log "ERROR" "Unknown Linux distribution"
    exit 1
})

# Define BASE system
ARCH=$([[ "$DISTRO" =~ ^(arch|manjaro|endeavouros|arcolinux|garuda) ]] && echo true || echo false)
DEBIAN=$([[ "$DISTRO" =~ ^(ubuntu|debian|mint|pop!_os|kali|zorin|elementary|mx|linuxlite|lubuntu|xubuntu) ]] && echo true || echo false)
FEDORA=$([[ "$DISTRO" =~ ^(fedora|rhel|centos|rocky|almalinux) ]] && echo true || echo false)

# Set BASE_DISTRO based on the first matching condition
if [ "$ARCH" == "true" ]; then
    BASE_DISTRO="arch"
elif [ "$DEBIAN" == "true" ]; then
    BASE_DISTRO="debian"
elif [ "$FEDORA" == "true" ]; then
    BASE_DISTRO="fedora"
else
    log "ERROR" "No matching distro found"
    exit 1
fi

IS_WSL=$(grep -qiE "(Microsoft|WSL)" /proc/version && echo true || echo false)
RUNNING_GNOME=$([[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]] && echo true || echo false)
RUNNING_HYPRLAND=$([[ "$XDG_CURRENT_DESKTOP" == *"Hyprland"* ]] && echo true || echo false)
SHOW_DEBUG=false

# Set the IS_ONLINE variable (true to check for internet, false to skip)
IS_ONLINE=true

# Determine the hostname and configuration file path
HOSTNAME=$(hostname)
CONFIG_FILE="$SCRIPT_DIR/config/hosts/${HOSTNAME}.conf"

# Make sure $WORK is unset
unset WORK

# Base config dir
CONFIG_DIR="$SCRIPT_DIR/config"

APPLICATIONS_DIR="$SCRIPT_DIR/applications"

# Parse script arguments
while [[ $# -gt 0 ]]; do
    case $1 in
    --work)
        WORK=true
        shift # Move to the next argument
        ;;
    --run-all)
        RUN_ALL=true
        shift # Move to the next argument
        ;;
    --file)
        SCRIPT_FILE="$2"
        shift 2 # Move to the next argument after the file name
        ;;
    *)
        log "WARNING" "Unknown option: $1"
        shift # Move to the next argument
        ;;
    esac
done

# Main process
main() {
    log "INFO" "Starting bootstrap process for $DISTRO ($BASE_DISTRO)"

    # Are we online
    check_online

    # Update main repo
    update_script

    # Load or create configuration file
    load_config

    # Check for sudo access
    has_sudo_access || {
        log "ERROR" "No sudo access"
        exit 1
    }

    # Get current running user
    USER=$(get_non_root_user)
    if [ $? -eq 0 ]; then
        log "INFO" "Current user: $USER"
    else
        log "ERROR" "Failed to determine a non-root user."
        exit 1
    fi

    # Are we in GNOME?
    if $RUNNING_GNOME; then
        # Ensure computer doesn't go to sleep or lock while installing
        gsettings set org.gnome.desktop.screensaver lock-enabled false
        gsettings set org.gnome.desktop.session idle-delay 0
    fi

    # Doing system update
    log "INFO" "Running system update"
    log "INFO" "This may take a while..."
    system_upgrade

    # Single script or folder scripts
    if [ -n "$SCRIPT_FILE" ]; then
        log "DEBUG" "Running single script mode"
        run_single_script $SCRIPT_FILE
    else
        # Install universal applications
        run_scripts_in_directory "$APPLICATIONS_DIR"
    fi

    # If on gnome
    if $RUNNING_GNOME; then
        # Revert to normal idle and lock settings
        gsettings set org.gnome.desktop.screensaver lock-enabled true
        gsettings set org.gnome.desktop.session idle-delay 900
    fi

    log "SUCCESS" "Bootstrap process completed"

    # Do we need a reboot?
    check_reboot_needed
}

# Execute the script
main
