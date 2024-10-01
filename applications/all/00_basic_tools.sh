log "INFO" "ALL: Installing basic packages"

packages=(software-properties-common python3-pip htop btop zsh tmux make sshpass cifs-utils pv libpam-u2f whiptail ripgrep unzip xclip)

for package in "${packages[@]}"; do
    if ! is_package_installed "$package"; then
        install_package "$package"
    fi
done

# sudo pipx ensurepath > /dev/null
