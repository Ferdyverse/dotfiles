#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Rofi menu for Quick Edit/View of Settings (SUPER E)

# Define preferred text editor and terminal
edit=${EDITOR:-nano}
tty=wezterm

# Paths to configuration directories
configs="$HOME/.config/hypr/configs"

# Function to display the menu options
menu() {
    cat <<EOF
1. Edit Env-variables
2. Edit Window-Rules
3. Edit Startup_Apps
4. Edit User-Keybinds
5. Edit Monitors
6. Edit Laptop-Keybinds
7. Edit User-Settings
8. Edit Decorations & Animations
9. Edit Workspace-Rules
10. Edit Default-Settings
11. Edit Default-Keybinds
EOF
}

# Main function to handle menu selection
main() {
    choice=$(menu | rofi -i -dmenu -config ~/.config/rofi/config-compact.rasi | cut -d. -f1)

    # Map choices to corresponding files
    case $choice in
    1) file="$configs/ENVariables.conf" ;;
    2) file="$configs/WindowRules.conf" ;;
    3) file="$configs/Startup_Apps.conf" ;;
    4) file="$configs/UserKeybinds.conf" ;;
    5) file="$configs/Monitors.conf" ;;
    6) file="$configs/Laptops.conf" ;;
    7) file="$configs/UserSettings.conf" ;;
    8) file="$configs/UserDecorAnimations.conf" ;;
    9) file="$configs/WorkspaceRules.conf" ;;
    10) file="$configs/Settings.conf" ;;
    11) file="$configs/Keybinds.conf" ;;
    *) return ;; # Do nothing for invalid choices
    esac

    # Open the selected file in the terminal with the text editor
    $tty -e $edit "$file"
}

main
