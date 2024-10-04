if ! is_package_installed "docker"; then
    install_package docker
fi

if ! is_package_installed "docker-compose"; then
    install_package docker-compose
fi
