
if ! type brew > /dev/null 2>&1; then
  export NONINTERACTIVE=1
  log "INFO" "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo '# Set PATH, MANPATH, etc., for Homebrew.' >> ~/.zprofile
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zprofile
fi

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_UPGRADE=1

brew bundle install --no-upgrade --no-lock --file "$SCRIPT_DIR/config/homebrew/linux/Brewfile"
