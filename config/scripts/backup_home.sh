#!/bin/bash

# Colors and text formats used in the script
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
LIGHT_BLUE="\e[94m"  # Lighter blue
BOLD="\e[1m"
RESET="\e[0m"

# Default Configuration File Path
DEFAULT_CONFIG_FILE="$HOME/.config/backup_script.conf"
CONFIG_FILE="$DEFAULT_CONFIG_FILE"

# Check if `pv` is installed
check_pv() {
    if command -v pv >/dev/null 2>&1; then
        PV_INSTALLED=true
    else
        PV_INSTALLED=false
    fi
}

# Load configuration file
load_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}Configuration file $CONFIG_FILE not found.${RESET}"
        exit 1
    fi

    # Load configuration file
    source "$CONFIG_FILE"

    # Verify required configurations
    if [ -z "$SMB_USERNAME" ] || [ -z "$SMB_PASSWORD" ] || [ -z "$SMB_SHARE" ]; then
        echo -e "${RED}Missing required configuration in $CONFIG_FILE.${RESET}"
        exit 1
    fi

    # Set backup directories and archive format
    IFS=' ' read -r -a backup_directories <<< "$BACKUP_DIRECTORIES"
    archive="$ARCHIVE_FORMAT"
    backup_folder="$BACKUP_DEST/$(hostname)"  # Folder for each host
}

# Display welcome message
welcome_message() {
    echo -e "${GREEN}${BOLD}Welcome to the Backup Script!${RESET}"
    echo -e "This script allows you to create and restore backups of important directories."
    echo -e "Ensure you have the necessary permissions and environment variables set."
    echo
}

# Display usage information
usage() {
    echo -e "${YELLOW}Usage: $0 [-b | -r | -l | -h] [-c config_file] [-n]${RESET}"
    echo -e "${YELLOW}Options:${RESET}"
    echo -e "  ${BOLD}-b${RESET}, ${BOLD}--backup${RESET}    Create a backup of the specified directories."
    echo -e "  ${BOLD}-r${RESET}, ${BOLD}--restore${RESET}   Restore a backup from the specified file."
    echo -e "  ${BOLD}-l${RESET}, ${BOLD}--list${RESET}      List available backups for all hosts."
    echo -e "  ${BOLD}-h${RESET}, ${BOLD}--help${RESET}      Display this help message."
    echo -e "  ${BOLD}-c${RESET}, ${BOLD}--config${RESET}    Specify a custom configuration file."
    echo -e "  ${BOLD}-n${RESET}, ${BOLD}--notify${RESET}    Send notifications to the REST service."
}

# Function to execute a command with sudo
execute_with_sudo() {
    sudo "$@"
}

# Function to send notifications to the REST service
send_notification() {
    if [ -z "$NOTIFY_URL" ]; then
        echo -e "${YELLOW}Notification URL not set. Skipping notification.${RESET}"
        return
    fi

    local status="$1"
    local message="$2"

    curl -X POST "$NOTIFY_URL" \
         -H "Content-Type: application/json" \
         -d "{\"status\": \"$status\", \"message\": \"$message\"}"
}

# Mount or unmount SMB share
smb_mount() {
    # Ensure /mnt/backup directory exists
    if [ ! -d "/mnt/backup" ]; then
        echo -e "${YELLOW}Creating /mnt/backup directory...${RESET}"
        execute_with_sudo mkdir -p /mnt/backup
    fi

    if mountpoint -q /mnt/backup; then
        echo -e "${LIGHT_BLUE}Unmounting SMB share...${RESET}"
        execute_with_sudo umount /mnt/backup
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}SMB share unmounted successfully${RESET}"
        else
            echo -e "${RED}Failed to unmount SMB share${RESET}"
            exit 1
        fi
    fi

    echo -e "${LIGHT_BLUE}Mounting SMB share...${RESET}"
    execute_with_sudo mount -t cifs -o username="$SMB_USERNAME",password="$SMB_PASSWORD",noperm "$SMB_SHARE" /mnt/backup
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}SMB share mounted successfully${RESET}"
    else
        echo -e "${RED}Failed to mount SMB share${RESET}"
        exit 1
    fi
}

# Creating backup with absolute paths
backup_home() {
    echo -e "${RED}${BOLD}Starting backup...${RESET}"
    smb_mount

    # Ensure backup directory exists
    mkdir -p "$backup_folder"

    # Check if directories are not empty
    for dir in "${backup_directories[@]}"; do
        if [ ! -d "$dir" ] || [ -z "$(ls -A "$dir")" ]; then
            echo -e "${YELLOW}Directory $dir is empty or does not exist. Skipping.${RESET}"
        fi
    done

    # Create backup archive with full paths
    echo -e "${LIGHT_BLUE}Creating backup archive: ${archive}${RESET}"
    if [ "$PV_INSTALLED" = true ]; then
        tar czf - -P "${backup_directories[@]}" | pv -s $(du -sb "${backup_directories[0]}" | awk '{print $1}') | tee "$backup_folder/$archive" > /dev/null
    else
        tar czf "$backup_folder/$archive" -P "${backup_directories[@]}"
    fi

    echo -e "${GREEN}Backup completed${RESET}"

    # Remove old backups
    echo -e "${YELLOW}Removing old backups...${RESET}"
    ls -t "$backup_folder"/*.tgz | tail -n +6 | xargs -r execute_with_sudo rm --

    smb_mount

    if [ "$NOTIFY" = true ]; then
        send_notification "success" "Backup completed successfully."
    fi
}

# Restoring backup with original paths
restore_backup() {
    smb_mount

    # Define a list of directories to ignore
    IGNORED_DIRS=("dump" "harald" "hass" "images" "template")

    # List available host directories excluding /mnt/backup and ignored directories
    echo -e "${YELLOW}Available host directories:${RESET}"
    host_dirs=()
    for dir in "$BACKUP_DEST"/*/; do
        dir_name=$(basename "$dir")
        if [ -d "$dir" ] && [ "$dir_name" != "backup" ] && [[ ! " ${IGNORED_DIRS[@]} " =~ " ${dir_name} " ]]; then
            host_dirs+=("$dir")
        fi
    done

    if [ ${#host_dirs[@]} -eq 0 ]; then
        echo -e "${RED}No host directories found.${RESET}"
        smb_mount
        exit 1
    fi

    # Convert host directory paths to just names for display
    host_dir_names=()
    for dir in "${host_dirs[@]}"; do
        host_dir_names+=("$(basename "$dir")")
    done

    select host_dir_name in "${host_dir_names[@]}"; do
        if [ -n "$host_dir_name" ]; then
            host_dir="${BACKUP_DEST}/${host_dir_name}"
            echo -e "${LIGHT_BLUE}Selected Host: $host_dir_name${RESET}"

            backups=("$host_dir"/*.tgz)
            if [ ${#backups[@]} -eq 0 ]; then
                echo -e "${RED}No backups found in this host directory.${RESET}"
                smb_mount
                exit 1
            fi

            # Convert backup file paths to just names for display
            backup_file_names=()
            for file in "${backups[@]}"; do
                backup_file_names+=("$(basename "$file")")
            done

            select backup_file_name in "${backup_file_names[@]}"; do
                if [ -n "$backup_file_name" ]; then
                    backup_file="$host_dir/$backup_file_name"
                    read -p "Are you sure you want to restore from $backup_file? (y/N): " confirm
                    if [[ "$confirm" =~ ^[Yy]$ ]]; then
                        # Create a temporary directory
                        temp_dir=$(mktemp -d)
                        echo -e "${LIGHT_BLUE}Restoring backup from $backup_file to temporary directory...${RESET}"

                        # Extract the backup to the temporary directory
                        if [ "$PV_INSTALLED" = true ]; then
                            pv "$backup_file" | tar xzf - -C "$temp_dir"
                        else
                            tar xzf "$backup_file" -C "$temp_dir"
                        fi

                        # Move the files to the correct location, avoiding permission changes
                        echo -e "${LIGHT_BLUE}Moving files to the original locations...${RESET}"
                        rsync -a --no-perms --no-owner --no-group --no-times "$temp_dir/" /

                        # Clean up the temporary directory
                        rm -rf "$temp_dir"

                        echo -e "${GREEN}Restore completed${RESET}"
                        break
                    else
                        echo -e "${YELLOW}Restore cancelled.${RESET}"
                        break
                    fi
                else
                    echo -e "${RED}Invalid selection. Try again.${RESET}"
                fi
            done
            break
        else
            echo -e "${RED}Invalid selection. Try again.${RESET}"
        fi
    done

    smb_mount

    if [ "$NOTIFY" = true ]; then
        send_notification "success" "Restore completed successfully."
    fi
}



# List backups for all hosts
list_backups() {
    smb_mount
    echo -e "${YELLOW}Available backups by host:${RESET}"
    
    # List directories for each host
    for host_dir in "$BACKUP_DEST"/*; do
        if [ -d "$host_dir" ]; then
            echo -e "${LIGHT_BLUE}Host: $(basename "$host_dir")${RESET}"
            ls -1 "$host_dir"/*.tgz 2>/dev/null || echo -e "${RED}  No backups found${RESET}"
        fi
    done
    
    smb_mount
}

# Main logic with short options
main() {
    while getopts ":brl:hc:n" opt; do
        case ${opt} in
            b)
                backup_home
                ;;
            r)
                restore_backup
                ;;
            l)
                list_backups
                ;;
            h)
                usage
                ;;
            c)
                CONFIG_FILE="$OPTARG"
                ;;
            n)
                NOTIFY=true
                ;;
            \?)
                echo -e "${RED}Invalid option: -${OPTARG}${RESET}" >&2
                usage
                exit 1
                ;;
            :)
                echo -e "${RED}Option -${OPTARG} requires an argument.${RESET}" >&2
                usage
                exit 1
                ;;
        esac
    done
    shift $((OPTIND -1))

    if [ $OPTIND -eq 1 ]; then
        usage
        exit 1
    fi
}

welcome_message
check_pv
load_config
main "$@"
