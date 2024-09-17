# Install Onedrive

if ! is_package_installed "onedrive"; then
    install_package onedrive
fi

create_symlink "$SCRIPT_DIR/config/onedrive/config" "$HOME/.config/onedrive/config"
create_symlink "$SCRIPT_DIR/config/onedrive/sync_list" "$HOME/.config/onedrive/sync_list"

sudo systemctl enable onedrive@$USER.service
sudo systemctl start onedrive@$USER.service
