if ! is_package_installed "wlogout"; then
    install_package wlogout
fi

create_symlink "$SCRIPT_DIR/config/wlogout" "$HOME/.config/wlogout"
