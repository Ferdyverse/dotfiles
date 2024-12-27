if ! is_package_installed "docker"; then
    install_package docker
fi

if ! is_package_installed "docker-compose"; then
    install_package docker-compose
fi

if ! is_package_installed "lazydocker"; then
    install_package lazydocker
fi
