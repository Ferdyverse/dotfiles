# Install Hyprland

copr_pkgs=(
  errornointernet/packages
  solopasha/hyprland
  erikreider/SwayNotificationCenter
)

packages_fedora=(
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
  qt6-5compat
  qt6-declarative
  qt6-qtsvg
)

packages_arch=(
  hyprland
  #waybar
  #rofi-wayland
  #swaync
  hyprlock
  hypridle
  xdg-desktop-portal-hyprland
  #sddm
  kitty
  #qt5-wayland
  #qt6-wayland
  #qt6-5compat
  #qt6-declarative
  #qt6-svg
  #cliphist
  thunar
  thunar-volman
  thunar-archive-plugin
  #network-manager-applet
  blueman
  brightnessctl
  #slurp
  #grim
  #xclip
  #swappy
  #gnome-themes-extra
  #gtk-engine-murrine
  #nwg-look
  #adw-gtk-theme
  #breeze-icons
  #kvantum
  #qt5ct
  #qt6ct
  libfido2
  udisks2
  yubikey-touch-detector
)

packages_yay=(
  #swww-git
  #pyprland
  #wallust
  #wlr-layout-ui
)

sddm_conf_dir=/etc/sddm.conf.d

create_symlink "$SCRIPT_DIR/config/hyprland" "$HOME/.config/hypr"

if $FEDORA; then
  for pkg in "${copr_pkgs[@]}"; do
    sudo dnf copr enable -y "$pkg"
  done

  dnf check-update

  for package in "${packages_fedora[@]}"; do
    is_package_installed "$package" || install_package "$package"
  done
fi

if $ARCH; then
  for package in "${packages_arch[@]}"; do
    is_package_installed "$package" || install_package "$package"
  done

  for package in "${packages_yay[@]}"; do
    is_package_installed "$package" || install_yay "$package"
  done
fi

# Rofi
create_symlink "$SCRIPT_DIR/config/rofi" "$HOME/.config/rofi"

# SwayNC
create_symlink "$SCRIPT_DIR/config/swaync" "$HOME/.config/swaync"

# Wallust
create_symlink "$SCRIPT_DIR/config/wallust" "$HOME/.config/wallust"

# Waybar
create_symlink "$SCRIPT_DIR/config/waybar" "$HOME/.config/waybar"

# You need to be in the input group to be able to access the keyboard state
sudo usermod -aG input $USER

# Link hostfile config
if [ ! -f "$SCRIPT_DIR/config/hyprland/configs/hosts/$HOSTNAME.conf" ]; then
  touch "$SCRIPT_DIR/config/hyprland/configs/hosts/$HOSTNAME.conf"
fi

create_symlink "$SCRIPT_DIR/config/hyprland/configs/hosts/$HOSTNAME.conf" "$HOME/.config/hypr/configs/current_host.conf"

#create_symlink "$SCRIPT_DIR/config/hyprland/scripts/clipboard_sync.sh" "$HOME/.local/bin/clipsync"

systemctl --user daemon-reload
systemctl --user enable --now yubikey-touch-detector.service
