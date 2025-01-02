if [ "$BASE_DISTRO" = "fedora" ]; then

    packages=(
        whiptail
        eza
        bat
        neovim
        variety
        dnf-plugins-core
    )

    for package in "${packages[@]}"; do
        if ! is_package_installed "$package"; then
            install_package "$package"
        fi
    done
fi
