is_package_installed "git" || install_package "git"

ensure_directories "$HOME/.config/git/"

create_symlink "$SCRIPT_DIR/config/git/gitconfig${WORK:+.work}" "$HOME/.gitconfig"
create_symlink "$SCRIPT_DIR/config/git/hooks" "$HOME/.config/git/hooks"

ensure_directories "$HOME/src/"
