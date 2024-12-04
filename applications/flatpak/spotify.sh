if ! is_package_installed "spotify"; then
    flatpak install -y flathub com.spotify.Client
fi
