if $ARCH; then
    if ! is_package_installed "ghostty"; then
        install_package ghostty
        install_package ttf-nerd-fonts-symbols-mono
    fi
fi

ensure_directories "$HOME/.config/ghostty"

create_symlink "$SCRIPT_DIR/config/ghostty/config" "$HOME/.config/ghostty/config"
