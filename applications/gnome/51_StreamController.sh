# A Software to use the StreamDeck on Linux systems

if ! is_package_installed "StreamController"; then
    flatpak install -y com.core447.StreamController
fi
