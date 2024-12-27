if ! is_package_installed "ulauncher"; then
    sudo add-apt-repository universe -y
    sudo add-apt-repository ppa:agornostal/ulauncher -y
    update_cache
    install_package ulauncher
    install_package wmctrl
fi
