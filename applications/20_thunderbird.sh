if [[ "$BASE_DISTRO" =~ ^(fedora|arch) ]]; then
    if ! is_package_installed "thunderbird"; then
        install_package thunderbird
    fi
fi
