is_package_installed "vim" || install_package "vim"

#is_package_installed "neovim" || install_package "neovim"

create_symlink "$SCRIPT_DIR/config/nvim" "$HOME/.config/nvim"
create_symlink "$SCRIPT_DIR/config/vim/vimrc" "$HOME/.vimrc"
