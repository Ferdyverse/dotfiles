# Docker Install
if $ARCH; then
  is_package_installed "docker" || install_package docker

  is_package_installed "docker-compose" || install_package docker-compose

  is_package_installed "docker-buildx" || install_package docker-buildx

  is_package_installed "lazydocker" || install_package lazydocker
fi

if $DEBIAN; then
  if ! is_package_installed "docker-ce"; then
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
      sudo apt-get remove -qq -y $pkg
    done

    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
      sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    update_cache

    for pkg in docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; do
      install_package $pkg
    done

    if ! [ $(getent group docker) ]; then
      sudo groupadd docker
    fi
    sudo usermod -aG docker $USER
    newgrp docker
  fi
fi

if $FEDORA; then
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
fi

sudo systemctl enable --now docker

sudo usermod -aG docker $USER
