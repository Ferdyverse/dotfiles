is_package_installed "variety" || install_package variety

if $RUNNING_HYPRLAND; then
    create_symlink "$SCRIPT_DIR/config/variety" "$HOME/.config/variety"
fi
