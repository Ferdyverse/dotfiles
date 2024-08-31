if ! is_package_installed "fastfatch"; then
    # Display system information in the terminal
    sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
    update_cache
    install_package fastfetch
fi