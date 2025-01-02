if $RUNNING_GNOME; then
    if [[ "$BASE_DISTRO" =~ ^(fedora|arch) ]]; then
        if ! is_package_installed "gdm-settings"; then
            install_package gdm-settings
        fi
    fi
fi
