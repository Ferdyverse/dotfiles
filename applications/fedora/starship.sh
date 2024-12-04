if ! is_package_installed "starship"; then
    sudo dnf copr -y enable atim/starship
    install_package starship
fi
