log "INFO" "Installing Gnome basic-tools"
install_package gnome-tweak-tool
install_package gnome-shell-extensions
install_package gnome-shell-extension-manager
pipx install gnome-extensions-cli --system-site-packages > /dev/null