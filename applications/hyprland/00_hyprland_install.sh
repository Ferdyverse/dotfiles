copr_pkgs=(
  errornointernet/packages
  solopasha/hyprland
  erikreider/SwayNotificationCenter
)

packages=(
    hyprland
    kitty
    hyprlock
    hypridle
    rofi-wayland
    SwayNotificationCenter
    swww
    pyprland
    wallust
    waybar
    wl-clipboard
    wlogout
    sddm
    pamixer
    pavucontrol
    grim
    slurp
    thunar
)

create_symlink "$SCRIPT_DIR/config/hyprland" "$HOME/.config/hypr"

for pkg in "${copr_pkgs[@]}"; do
    sudo dnf copr enable -y  "$pkg"
done

dnf check-update

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
