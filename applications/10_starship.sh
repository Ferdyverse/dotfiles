if $FEDORA; then
    if ! is_package_installed "starship"; then
        sudo dnf copr -y enable atim/starship
        install_package starship
    fi
fi

if $ARCH; then
    is_package_installed "starship" || install_package starship
fi
