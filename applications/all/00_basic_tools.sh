log "INFO" "ALL: Installing basic packages"

packages=(htop btop zsh make sshpass cifs-utils pv ripgrep unzip xclip whiptail)

for package in "${packages[@]}"; do
    if ! is_package_installed "$package"; then
        install_package "$package"
    fi
done

# sudo pipx ensurepath > /dev/null
