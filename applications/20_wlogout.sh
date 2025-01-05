if $RUNNING_HYPRLAND; then
    is_package_installed "wlogout" || install_package wlogout

    create_symlink "$SCRIPT_DIR/config/wlogout" "$HOME/.config/wlogout"
fi
