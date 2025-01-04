if $FEDORA; then
    if ! is_package_installed "onedrive"; then
        install_package onedrive
    fi
fi

ensure_directories "$HOME/.config/onedrive"
create_symlink "$SCRIPT_DIR/config/onedrive/config" "$HOME/.config/onedrive/config"
create_symlink "$SCRIPT_DIR/config/onedrive/sync_list" "$HOME/.config/onedrive/sync_list"
