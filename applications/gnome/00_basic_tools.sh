log "INFO" "Installing Gnome basic-tools"
install_package gnome-tweak-tool
install_package gnome-shell-extensions
install_package gnome-shell-extension-manager
pipx install gnome-extensions-cli --system-site-packages > /dev/null
log "SUCCESS" "Gnome basic-tools installed!"

log "INFO" "Installing Gnome extensions"
gext --no-color install quick-settings-tweaks@qwreey > /dev/null
gext --no-color install dash-to-panel@jderose9.github.com > /dev/null
gext --no-color install arcmenu@arcmenu.com > /dev/null
log "SUCCESS" "Gnome bextensions installed!"