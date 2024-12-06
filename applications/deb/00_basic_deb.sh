packages=(pipx fd-find software-properties-common python3-pip libpam-u2f whiptail ssh)

for package in "${packages[@]}"; do
    if ! is_package_installed "$package"; then
        install_package "$package"
    fi
done
