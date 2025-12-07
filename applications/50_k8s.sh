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
  fi
fi

if $ARCH; then
  is_package_installed "kubectl" || install_package kubectl

  is_package_installed "k9s" || install_package k9s
fi
