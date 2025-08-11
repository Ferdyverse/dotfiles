is_package_installed "git" || install_package "git"

ensure_directories "$HOME/.config/git/"

create_symlink "$SCRIPT_DIR/config/git/gitconfig${WORK:+.work}" "$HOME/.gitconfig"
create_symlink "$SCRIPT_DIR/config/git/hooks" "$HOME/.config/git/hooks"

ensure_directories "$HOME/src/"

if $DEBIAN; then
  wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.deb -O /tmp/gcm.deb
  sudo dpkg -i /tmp/gcm.deb -y
  rm /tmp/gcm.deb
fi
