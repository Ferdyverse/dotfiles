# create_symlink "$SCRIPT_DIR/config/ags" "$HOME/.config/ags"

copr_pkgs=(
    heus-sueh/packages
)

packages=(
    pipewire
    libgtop2
    bluez
    bluez-tools
    grimblast
    hyprpicker
    btop
    NetworkManager
    wl-clipboard
    swww
    brightnessctl
    gnome-bluetooth
    aylurs-gtk-shell
    gvfs
    matugen
)

for pkg in "${copr_pkgs[@]}"; do
    sudo dnf copr enable -y "$pkg"
done

for package in "${packages[@]}"; do
    if ! is_package_installed "$package"; then
        install_package "$package"
    fi
done

curl -fsSL https://bun.sh/install | bash

bun install -g sass

clone_repository https://github.com/Jas-SinghFSU/HyprPanel.git "$HOME/.config/ags"
