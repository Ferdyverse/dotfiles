log "INFO" "Installing Gnome extensions"
gext --no-color install quick-settings-tweaks@qwreey
gext --no-color install dash-to-panel@jderose9.github.com
gext --no-color install arcmenu@arcmenu.com
gext --no-color install tactile@lundal.io
gext --no-color install blur-my-shell@aunetx

gnome-extensions disable tiling-assistant@ubuntu.com
gnome-extensions disable ubuntu-dock@ubuntu.com

log "INFO" "Compile gsettings"
sudo cp ~/.local/share/gnome-shell/extensions/tactile@lundal.io/schemas/org.gnome.shell.extensions.tactile.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/blur-my-shell\@aunetx/schemas/org.gnome.shell.extensions.blur-my-shell.gschema.xml /usr/share/glib-2.0/schemas/
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/