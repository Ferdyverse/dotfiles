is_package_installed "git" || install_package "git"

create_symlink "$SCRIPT_DIR/config/git/gitconfig${WORK:+.work}" "$HOME/.gitconfig"

ensure_directories "$HOME/src/"