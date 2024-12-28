if [[ "$DISTRO" =~ ^(manjaro|arch|endeavouros) ]]; then
    install_package "spotify-launcher"
elif ! is_package_installed "spotify"; then
    flatpak install -y flathub com.spotify.Client
fi
