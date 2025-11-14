is_package_installed "tmux" || install_package "tmux"

clone_repository "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"

create_symlink "$SCRIPT_DIR/config/tmux/tmux.conf" "$HOME/.tmux.conf"

# Link every file in custom_scripts folder
for script in "$SCRIPT_DIR/config/tmux/custom_scripts/"*; do
    if [[ -f "$script" ]]; then
        mkdir -p "$HOME/.tmux/plugins/tmux/scripts"
        create_symlink "$script" "$HOME/.tmux/plugins/tmux/scripts/$(basename "$script")"
    fi
done
