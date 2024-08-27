#!/bin/bash

# Colors and text formats
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
LIGHT_BLUE="\e[94m"  # Lighter blue
BOLD="\e[1m"
RESET="\e[0m"

# Default actions and options
ADD_U2F_KEY=false
CONFIGURE_PAM=false
TEST_MODE=false
REVERT_MODE=false
USERNAME="$(logname)"
BACKUP_DIR="/var/backups/pam_u2f"

# Welcome message
echo -e "${LIGHT_BLUE}${BOLD}Welcome to the U2F Key Mapping and PAM Configuration Script${RESET}"

# Function to display usage information
usage() {
  echo -e "${BOLD}Usage:${RESET}"
  echo -e "  $0 [options]"
  echo -e ""
  echo -e "${BOLD}Options:${RESET}"
  echo -e "  --help, -h           Show this help message"
  echo -e "  --username, -u       Specify the username for U2F mapping"
  echo -e "  --add-key, -k        Add U2F Key Mapping only"
  echo -e "  --configure-pam, -c  Configure PAM Services only"
  echo -e "  --all, -a            Run both actions (default)"
  echo -e "  --test, -t           Run in test mode without making changes"
  echo -e "  --revert, -r         Revert changes based on backups"
  echo -e "  --backup-dir, -b     Specify a backup directory (default: /var/backups/pam_u2f)"
  exit 0
}

# Check if a command is available
check_command() {
  local cmd=$1
  if ! command -v "$cmd" &> /dev/null; then
    echo -e "${RED}${BOLD}Error: $cmd command not found. Please install it first.${RESET}"
    exit 1
  fi
}

# Function to create backup
create_backup() {
  local file=$1
  local backup_file="${BACKUP_DIR}/$(basename "$file")-$(date +%F_%T)"
  mkdir -p "$BACKUP_DIR"
  cp "$file" "$backup_file"
  echo -e "Backup created: $backup_file"
}

# Check if running as root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
  echo -e "${RED}${BOLD}Error: This script must be run as root.${RESET}"
  exit 1
fi

# Parse arguments
while [[ "$1" != "" ]]; do
  case $1 in
    --help | -h)
      usage
      ;;
    --username | -u)
      shift
      USERNAME=$1
      ;;
    --add-key | -k)
      ADD_U2F_KEY=true
      ;;
    --configure-pam | -c)
      CONFIGURE_PAM=true
      ;;
    --all | -a)
      ADD_U2F_KEY=true
      CONFIGURE_PAM=true
      ;;
    --test | -t)
      TEST_MODE=true
      ;;
    --revert | -r)
      REVERT_MODE=true
      ;;
    --backup-dir | -b)
      shift
      BACKUP_DIR=$1
      ;;
    *)
      echo -e "${RED}${BOLD}Unknown parameter: $1${RESET}"
      usage
      ;;
  esac
  shift
done

# If no parameters are provided, show usage
if [[ "$ADD_U2F_KEY" == false && "$CONFIGURE_PAM" == false && "$REVERT_MODE" == false ]]; then
  usage
fi

# Check for necessary commands
check_command "pamu2fcfg"
check_command "grep"
check_command "awk"

# Function to add U2F Key Mapping
add_u2f_key() {
  echo -e "${BLUE}Preparing to add U2F key for user $USERNAME...${RESET}"
  
  if [[ -z "$USERNAME" ]]; then
    echo -e "${RED}${BOLD}Error: Username not set. Please use the --username or -u option.${RESET}"
    exit 1
  fi

  # Confirm with the user
  echo -e "${YELLOW}A U2F mapping will be generated for the user '$USERNAME'.${RESET}"
  read -p "Is this correct? (Y/N, default Y): " REPLY
  REPLY=${REPLY:-Y}
  echo

  if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}${BOLD}Please run the script again with the appropriate options.${RESET}"
    exit 1
  fi

  if [[ "$TEST_MODE" = true ]]; then
    echo -e "${YELLOW}${BOLD}Test mode enabled. No changes will be made.${RESET}"
    return
  fi

  # Ensure sudo is active and generate the U2F mapping
  sudo -v
  echo -e "${LIGHT_BLUE}Enter PIN if required, then press the button on the device.${RESET}"
  
  # Write the U2F mapping to the file
  pamu2fcfg -u "$USERNAME" >> /etc/u2f_mappings

  if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}${BOLD}U2F mapping successfully created for '$USERNAME' and saved to /etc/u2f_mappings.${RESET}"
  else
    echo -e "${RED}${BOLD}Error creating the U2F mapping.${RESET}"
    exit 1
  fi
}

# Function to configure PAM services
configure_pam_services() {
  echo -e "${BLUE}Preparing to configure PAM services...${RESET}"

  # List of services to update policy for
  SERVICES=(
    lightdm
    sudo
    sudo-i
    su
    chsh
    login
    polkit-1
    xscreensaver
    gdm-password
    gdm-smartcard-sssd-or-password
    ppp
    unity
    cinnamon-screensaver
    gnome-screensaver
  )

  # Navigate to the PAM directory
  cd /etc/pam.d || exit 1

  # Create the common-u2f file with the required configuration
  echo 'auth sufficient pam_u2f.so authfile=/etc/u2f_mappings cue [cue_prompt=Go, touch it now!]' > common-u2f

  # Iterate over the list of services and update their PAM configuration
  for f in "${SERVICES[@]}"; do
    if [ ! -f "$f" ]; then
      echo -e "${YELLOW}[SKIP] $f does not exist${RESET}"
      continue
    fi

    if [[ "$TEST_MODE" = true ]]; then
      echo -e "${YELLOW}${BOLD}Test mode enabled. Changes for $f would be applied.${RESET}"
      continue
    fi

    if grep -Fxq "@include common-u2f" "$f"; then
      echo -e "${BLUE}[SKIP] Updated policy exists in $f${RESET}"
    else
      create_backup "$f"
      mv "$f" "$f~"
      awk '/@include common-auth/ {print "@include common-u2f"} {print}' "$f~" > "$f"
      echo -e "${GREEN}${BOLD}[UPDATE] Added common-u2f to $f${RESET}"
    fi
  done

  echo -e "${GREEN}${BOLD}PAM configuration updated for U2F.${RESET}"
}

# Function to revert changes based on backups
revert_changes() {
  echo -e "{BLUE}Reverting changes based on backups...${RESET}"

  for f in /etc/pam.d/*; do
    if [ -f "$f~" ]; then
      mv "$f~" "$f"
      echo -e "${GREEN}${BOLD}Reverted $f from backup.${RESET}"
    fi
  done

  echo -e "${GREEN}${BOLD}All changes reverted successfully.${RESET}"
}

# Main script execution
if [[ "$REVERT_MODE" = true ]]; then
  revert_changes
  exit 0
fi

if [[ "$ADD_U2F_KEY" = true ]]; then
  add_u2f_key
fi

if [[ "$CONFIGURE_PAM" = true ]]; then
  configure_pam_services
fi

echo -e "${GREEN}${BOLD}Script completed successfully.${RESET}"
