if ! is_package_installed "wezterm"; then
    sudo dnf copr -y enable wezfurlong/wezterm-nightly
    install_package wezterm
fi

ensure_directories "$HOME/.config/wezterm"

create_symlink "$SCRIPT_DIR/config/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
