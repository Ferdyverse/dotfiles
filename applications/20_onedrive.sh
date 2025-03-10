if $FEDORA; then
    is_package_installed "onedrive" || install_package onedrive
fi

if $ARCH; then
    is_package_installed "onedrive" || install_yay onedrive-abraunegg
fi

ensure_directories "$HOME/.config/onedrive"
create_symlink "$SCRIPT_DIR/config/onedrive/config" "$HOME/.config/onedrive/config"
create_symlink "$SCRIPT_DIR/config/onedrive/sync_list" "$HOME/.config/onedrive/sync_list"
