# Wireguard GUI
if $RUNNING_GNOME; then
    if [ "$BASE_DISTRO" = "debian" ]; then
        if ! is_package_installed "wireguird"; then
            cd /tmp
            wget -L https://github.com/UnnoTed/wireguird/releases/download/v1.1.0/wireguird_amd64.deb -O wireguird_amd64.deb
            sudo apt-get -qq install -y ./wireguird_amd64.deb
            rm wireguird_amd64.deb

            cd -
        fi
    fi
fi
