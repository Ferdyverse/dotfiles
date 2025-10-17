
# As this package is not installed via a package manager, we need to check if the file exists
if [ ! -f "/usr/local/bin/olm" ]; then
    log "INFO" "Installing OLM"
    LATEST_VERSION=$(get_latest_version "fosrl" "olm")
    log "INFO" "Found version: $LATEST_VERSION"
    sudo wget https://github.com/fosrl/olm/releases/download/${LATEST_VERSION}/olm_linux_amd64 -O /usr/local/bin/olm
    sudo chmod +x /usr/local/bin/olm
    log "SUCCESS" "Installed olm"

    # Create symlink for service
    sudo ln -sf "$SCRIPT_DIR/config/olm/olm.service${WORK:+.work}" "/etc/systemd/system/olm.service"
fi
