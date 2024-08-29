is_package_installed "git" || install_package "git"

if [ "$WORK" = true ]; then
    create_symlink "$SCRIPT_DIR/config/git/gitconfig.work" "$HOME/.gitconfig"
else
    create_symlink "$SCRIPT_DIR/config/git/gitconfig" "$HOME/.gitconfig"
fi