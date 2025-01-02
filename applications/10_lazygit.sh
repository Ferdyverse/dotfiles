if [ "$BASE_DISTRO" = "fedora" ]; then
    if ! is_package_installed "lazygit"; then
        sudo dnf copr -y enable atim/lazygit
        install_package lazygit
    fi
fi

if [ "$BASE_DISTRO" = "arch" ]; then
    if ! is_package_installed "lazygit"; then
        install_package lazygit
    fi
fi
