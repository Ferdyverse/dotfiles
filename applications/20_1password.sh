if [ "$BASE_DISTRO" = "debian" ]; then
    if ! is_package_installed "1password"; then
        log "INFO" "Updating apt repos"
        curl -sS https://downloads.1password.com/linux/keys/1password.asc |
            sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

        # Add apt repository
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | sudo tee /etc/apt/sources.list.d/1password.list

        # Add the debsig-verify policy
        sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
        curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol |
            sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
        sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
        curl -sS https://downloads.1password.com/linux/keys/1password.asc |
            sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

        log "INFO" "New Repos added"

        # Install 1Password & 1password-cli
        update_cache
        install_package 1password
        install_package 1password-cli
    fi
fi

if [ "$BASE_DISTRO" = "fedora" ]; then
    if ! is_package_installed "1password"; then
        sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
        sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
        install_package 1password
    fi
fi

if [ "$BASE_DISTRO" = "arch" ]; then
    if ! is_package_installed "1password"; then
        install_package 1password
    fi
fi
