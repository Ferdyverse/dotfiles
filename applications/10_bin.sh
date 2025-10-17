
# As this package is not installed via a package manager, we need to check if the file exists
if [ ! -f "$HOME/.local/bin/bin" ]; then
    log "INFO" "Installing Bin package manager"
    LATEST_VERSION=$(get_latest_version "marcosnils" "bin")
    wget https://github.com/marcosnils/bin/releases/download/v${LATEST_VERSION}/bin_${LATEST_VERSION}_linux_amd64 -O /tmp/bin
    # Bin should install itself
    chmod +x /tmp/bin
    /tmp/bin install github.com/marcosnils/bin
    rm /tmp/bin
    log "SUCCESS" "Installed Bin package manager"

    # Create symlink for config.json
    create_symlink "$SCRIPT_DIR/config/bin/config.json${WORK:+.work}" "$HOME/.config/bin/config.json"

    # Install all bins from config
    log "INFO" "Installing all bins from config"
    $HOME/.local/bin/bin ensure
    log "SUCCESS" "Installed all bins from config"
fi
