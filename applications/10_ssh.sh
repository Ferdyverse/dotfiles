ensure_directories "$HOME/.ssh/include/"

create_symlink "$SCRIPT_DIR/config/ssh/config${WORK:+.work}" "$HOME/.ssh/config"
