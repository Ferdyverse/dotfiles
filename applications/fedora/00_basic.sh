packages=(
    whiptail
    eza
    bat
    neovim
    variety
    lazygit
)

for package in "${packages[@]}"; do
    if ! is_package_installed "$package"; then
        install_package "$package"
    fi
done
