if [ "$BASE_DISTRO" = "fedora" ]; then
    if ! is_package_installed "starship"; then
        sudo dnf copr -y enable atim/starship
        install_package starship
    fi
fi

if [ "$BASE_DISTRO" = "arch" ]; then
    if ! is_package_installed "starship"; then
        install_package starship
    fi
fi
