if $FEDORA; then
    if ! is_package_installed "starship"; then
        sudo dnf copr -y enable atim/starship
        install_package starship
    fi
fi

if $ARCH; then
    if ! is_package_installed "starship"; then
        install_package starship
    fi
fi
