if [ "$BASE_DISTRO" = "arch" ]; then
    if ! is_package_installed "spotify-launcher"; then
        install_package "spotify-launcher"
    fi
fi

if [ "$BASE_DISTRO" = "debian" ]; then
    if ! is_package_installed "spotify-client"; then
        curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
        echo "deb [signed-by=/etc/apt/trusted.gpg.d/spotify.gpg] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
        update_cache
        install_package spotify-client
    fi
fi
