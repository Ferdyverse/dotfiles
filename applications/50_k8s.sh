# Install kubernetes tools

ensure_directories "$HOME/.kube"

if $DEBIAN; then
  # Install kubectl
  if [ ! /usr/local/bin/kubectl ]; then
    log "INFO" "Installing kubectl"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    log "SUCCESS" "Installed kubectl"
  fi

  # Install k9s
  if [ ! -f "/usr/bin/k9s" ]; then
    log "INFO" "Installing k9s"
    wget https://github.com/derailed/k9s/releases/latest/download/k9s_linux_amd64.deb -O /tmp/k9s.deb
    sudo apt install /tmp/k9s.deb
    rm /tmp/k9s.deb
  fi
fi

if $ARCH; then
  is_package_installed "kubectl" || install_package kubectl

  is_package_installed "k9s" || install_package k9s
fi
