if [[ "$BASE_DISTRO" =~ ^(fedora|arch) ]]; then
    is_package_installed "thunderbird" || install_package thunderbird
fi
