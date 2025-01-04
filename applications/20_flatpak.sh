if ! is_package_installed "flatpak"; then
    install_package flatpak
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
fi

if $DEBIAN; then
    if ! is_package_installed "gnome-software-plugin-flatpak"; then
        install_package gnome-software-plugin-flatpak
    fi
fi
