if $FEDORA; then
    if ! is_package_installed "lazygit"; then
        sudo dnf copr -y enable atim/lazygit
        install_package lazygit
    fi
fi

if $ARCH; then
    if ! is_package_installed "lazygit"; then
        install_package lazygit
    fi
fi
