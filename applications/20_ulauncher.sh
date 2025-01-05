if $RUNNING_GNOME; then

    if [[ "$BASE_DISTRO" =~ ^(fedora|arch) ]]; then
        is_package_installed "ulauncher" || install_package ulauncher
    fi

    if $DEBIAN; then
        if ! is_package_installed "ulauncher"; then
            sudo add-apt-repository universe -y
            sudo add-apt-repository ppa:agornostal/ulauncher -y
            update_cache
            install_package ulauncher
            install_package wmctrl
        fi
    fi

fi
