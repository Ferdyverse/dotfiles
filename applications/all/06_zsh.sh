log "INFO" "Installing ZSH..."

is_package_installed "zsh" || install_package "zsh"

ensure_directories "$HOME/.config/"

create_symlink "$SCRIPT_DIR/config/zsh/alias" "$HOME/.alias"
create_symlink "$SCRIPT_DIR/config/zsh/custom_env" "$HOME/.custom_env"
create_symlink "$SCRIPT_DIR/config/zsh/starship.toml" "$HOME/.config/starship.toml"

log "INFO" "Installing oh-my-zsh..."
if [ -d $HOME/.oh-my-zsh ]; then
    if [ ! -d $HOME/.oh-my-zsh/.git ]; then
        rm -rf $HOME/.oh-my-zsh
    fi
elif [ ! -d $HOME/.oh-my-zsh ]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ "$WORK" = true ]; then
    create_symlink "$SCRIPT_DIR/config/zsh/zshrc.work" "$HOME/.zshrc"
else
    create_symlink "$SCRIPT_DIR/config/zsh/zshrc" "$HOME/.zshrc"
fi

if [ -d ~/.oh-my-zsh ]; then
    clone_repository "https://github.com/zsh-users/zsh-autosuggestions" "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    clone_repository "https://github.com/hsaunders1904/pyautoenv.git" "$HOME/.oh-my-zsh/custom/plugins/pyautoenv"
fi

log "INFO" "Make ZSH to default shell..."
log "WARNING" "I did not find a way to do this without entering the sudo password"
sudo chsh -s $(which zsh) $USER

log "INFO" "ZSH done!"
