packages=(noto-fonts-emoji base-devel yay python-pipx fd)

for package in "${packages[@]}"; do
    if ! is_package_installed "$package"; then
        install_package "$package"
    fi
done
