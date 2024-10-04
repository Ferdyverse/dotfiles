packages=(noto-fonts-emoji base-devel python-pipx fd)

for package in "${packages[@]}"; do
    if ! is_package_installed "$package"; then
        install_package "$package"
    fi
done

# Enable third party packages
create_symlink "$SCRIPT_DIR/config/misc/pamac/pamac.conf" "/etc/pamac.conf"
