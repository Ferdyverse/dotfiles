if $DEBIAN; then
    if ! is_package_installed "steam-launcher"; then
        cd /tmp
        wget http://media.steampowered.com/client/installer/steam.deb
        sudo dpkg --add-architecture i386
        update_cache
        sudo apt-get -qq install -y ./steam.deb
        rm steam.deb
        cd -
    fi
fi

if $FEDORA; then
    if ! is_package_installed "steam"; then
        install_package steam
    fi
fi

if $ARCH; then
    if ! is_package_installed "steam"; then
        install_package steam
    fi
fi
