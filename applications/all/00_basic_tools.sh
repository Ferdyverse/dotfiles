log "INFO" "DEB: Installing basic packages"

packages=(software-properties-common python3-pip htop btop zsh tmux make sshpass cifs-utils pv libpam-u2f pipx whiptail ripgrep unzip xclip fd)

for package in "${packages[@]}"; do
    if ! is_package_installed "$package"; then
        install_package "$package"
    fi
done

# sudo pipx ensurepath > /dev/null
