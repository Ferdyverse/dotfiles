
cd $HOME/.dotfiles

if [ "$WORK" = true ]; then
    git remote set-url origin https://github.com/Brazier85/dotfiles_bash.git
else
    git remote set-url origin git@github.com:Brazier85/dotfiles_bash.git
fi

log "SUCCESS" "Cleanup done!"