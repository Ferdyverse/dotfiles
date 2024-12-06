docker_pkg=(
    docker-ce
    docker-ce-cli
    containerd.io
    docker-buildx-plugin
    docker-compose-plugin
)

sudo dnf-3 config-manager -y --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

# Install additional Nvidia packages
for package in "${docker_pkg[@]}"; do
    if ! is_package_installed "$package"; then
        install_package "$package"
        if [ $? -ne 0 ]; then
            log "ERROR" "$package Installation failed. Check the install log."
            exit 1
        fi
    fi
done

sudo systemctl enable --now docker

sudo usermod -aG docker $USER
