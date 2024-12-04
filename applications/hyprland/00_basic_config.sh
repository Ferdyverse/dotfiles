create_symlink "$SCRIPT_DIR/config/hyprland" "$HOME/.config/hypr"

packages=(
    hyprland
    kitty
    hyprlock
    pyprland
    hypridle
    rofi-wayland
    SwayNotificationCenter
    swww
    wallust
    waybar
    wl-clipboard
    wlogout
    ssdm
)

for package in "${packages[@]}"; do
    if ! is_package_installed "$package"; then
        install_package "$package"
    fi
done

# Check if other login managers are installed and disabling their service before enabling sddm
for login_manager in lightdm gdm lxdm lxdm-gtk3; do
  if sudo dnf list installed "$login_manager" &>> /dev/null; then
    log "INFO" "Disabling $login_manager..."
    sudo systemctl disable "$login_manager"
  fi
done

log "CINFO" "Activating sddm service........\n"
sudo systemctl set-default graphical.target
sudo systemctl enable sddm.service
