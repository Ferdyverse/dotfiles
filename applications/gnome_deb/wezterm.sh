if ! is_package_installed "wezterm"; then
    install_package wezterm
fi

ensure_directories "$HOME/.config/wezterm"

create_symlink "$SCRIPT_DIR/config/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
