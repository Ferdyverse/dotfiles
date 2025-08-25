if $DEBIAN; then
  is_package_installed "tmux" || install_package "tmux"

  clone_repository "https://github.com/gpakosz/.tmux.git" "$SCRIPT_DIR/repos/oh-my-tmux"

  create_symlink "$SCRIPT_DIR/repos/oh-my-tmux/.tmux.conf" "$HOME/.tmux.conf"
  create_symlink "$SCRIPT_DIR/config/tmux/tmux.conf.local" "$HOME/.tmux.conf.local"
fi
