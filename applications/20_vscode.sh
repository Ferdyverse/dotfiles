if $FEDORA; then
    if ! is_package_installed "code"; then
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null
        dnf check-update
        install_package code
    fi
fi

if $ARCH; then
    if ! is_package_installed "code"; then
        install_yay visual-studio-code-bin
    fi
fi

if $DEBIAN; then
    if ! is_package_installed "code"; then
        cd /tmp
        wget -O code.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
        sudo apt install -y ./code.deb
        rm code.deb
        cd -
    fi
fi
