log "INFO" "Installing SSH..."

is_package_installed "ssh" || install_package "ssh"

ensure_directories "$HOME/.ssh/"

create_symlink "$SCRIPT_DIR/config/ssh/config${WORK:+.work}" "$HOME/.ssh/config"

log "INFO" "SSH done"