if ! is_package_installed "variety"; then
    nstall_package variety
fi

if $RUNNING_HYPRLAND; then
    create_symlink "$SCRIPT_DIR/config/variety" "$HOME/.config/variety"
fi
