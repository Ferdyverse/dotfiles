# Install kubernetes tools

if $DEBIAN; then
  # Install kubectl
  if [ !/usr/local/bin/kubectl ]; then
    log "INFO" "Installing kubectl"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    log "SUCCESS" "Installed kubectl"
  fi

  # Install k9s
  if [ ! -f "/usr/local/bin/k9s" ]; then
    log "INFO" "Installing k9s"
    wget https://github.com/derailed/k9s/releases/latest/download/k9s_linux_amd64.deb
    sudo apt install ./k9s_linux_amd64.deb
    rm k9s_linux_amd64.deb

if $ARCH; then
  is_package_installed "kubectl" || install_package kubectl

  is_package_installed "k9s" || install_package k9s

  is_package_installed "docker-buildx" || install_package docker-buildx

  is_package_installed "lazydocker" || install_package lazydocker
fi

if $DEBIAN; then
  if ! is_package_installed "docker-ce"; then
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
      sudo apt-get remove -qq -y $pkg
    done

    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
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
