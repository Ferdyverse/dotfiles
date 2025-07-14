ensure_directories "$HOME/.ssh/"

create_symlink "$SCRIPT_DIR/config/ssh/config${WORK:+.work}" "$HOME/.ssh/config"

create_symlink "$SCRIPT_DIR/config/ssh/include${WORK:+.work}" "$HOME/.ssh/include"
