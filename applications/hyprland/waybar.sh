create_symlink "$SCRIPT_DIR/config/waybar" "$HOME/.config/waybar"

# You need to be in the input group to be able to access the keyboard state
sudo usermod -aG input $USER
