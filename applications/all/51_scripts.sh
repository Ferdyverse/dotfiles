# Add links to custom scripts

log "INFO" "Installing custom scripts..."

ensure_directories "$HOME/.local/bin/"

create_symlink "$SCRIPT_DIR/config/scripts/backup_home.sh" "$HOME/.local/bin/backup_home"
create_symlink "$SCRIPT_DIR/config/scripts/backup_script.conf" "$HOME/.config/backup_script.conf"
create_symlink "$SCRIPT_DIR/config/scripts/update_login.sh" "$HOME/.local/bin/update_login"

chmod +x "$HOME/.local/bin/backup_home"
