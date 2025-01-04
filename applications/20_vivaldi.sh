if $DEBIAN; then
    if ! is_package_installed "vivaldi-stable"; then
        cd /tmp
        wget -L https://vivaldi.com/download/vivaldi-stable_amd64.deb -O vivaldi.deb
        sudo apt-get -qq install -y ./vivaldi.deb
        rm vivaldi.deb
        cd -
    fi
fi

if $ARCH; then
    if ! is_package_installed "vivaldi"; then
        install_package vivaldi
    fi
fi
