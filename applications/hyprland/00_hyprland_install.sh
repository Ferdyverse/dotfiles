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

sddm_conf_dir=/etc/sddm.conf.d

create_symlink "$SCRIPT_DIR/config/hyprland" "$HOME/.config/hypr"

for pkg in "${copr_pkgs[@]}"; do
  sudo dnf copr enable -y "$pkg"
done

dnf check-update

for package in "${packages[@]}"; do
  if ! is_package_installed "$package"; then
    install_package "$package"
  fi
done

log "INFO" "Starting SDDM config"
ensure_directories "/usr/share/sddm/themes/"

clone_repository "https://github.com/JaKooLit/simple-sddm-2.git" "$HOME/.dotfiles/repos/simple-sddm-2"
sudo mv "$HOME/.dotfiles/repos/simple-sddm-2" "/usr/share/sddm/themes/"
echo -e "[Theme]\nCurrent=simple-sddm-2" | sudo tee "$sddm_conf_dir/theme.conf.user"

log "INFO" "Removing other Login Managers"
# Check if other login managers are installed and disabling their service before enabling sddm
for login_manager in lightdm gdm lxdm lxdm-gtk3; do
  if sudo dnf list installed "$login_manager" &>>/dev/null; then
    log "INFO" "Disabling $login_manager..."
    sudo systemctl disable "$login_manager"
  fi
done

log "CINFO" "Activating sddm service........\n"
sudo systemctl set-default graphical.target
sudo systemctl enable sddm.service
