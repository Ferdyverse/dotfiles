# Add custom nerd fonts

# Define the system font directory
local SYSTEM_FONT_DIR="$HOME/.local/share/fonts"

local SCRIPT_FONT_DIR="$SCRIPT_DIR/config/fonts"

for f in $SCRIPT_FONT_DIR/*.ttf; do
    log "INFO" "Copy file: $f"
    cp "$f" "$SYSTEM_FONT_DIR"
done

for f in $SCRIPT_FONT_DIR/*.otf; do
    log "INFO" "Copy file: $f"
    cp "$f" "$SYSTEM_FONT_DIR"
done

if [ "$BASE_DISTRO" = "fedora" ]; then
    fonts=(
        adobe-source-code-pro-fonts
        fira-code-fonts
        fontawesome-fonts-all
        google-droid-sans-fonts
        google-noto-sans-cjk-fonts
        google-noto-color-emoji-fonts
        google-noto-emoji-fonts
        jetbrains-mono-fonts
    )

    for PKG1 in "${fonts[@]}"; do
        install_package "$PKG1"
        if [ $? -ne 0 ]; then
            echo -e "${ERROR} - $PKG1 Installation failed. Check the install log."
            exit 1
        fi
    done
fi

# jetbrains nerd font. Necessary for waybar
log "INFO" "Downloading JetBrains Font"
DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
# Maximum number of download attempts
MAX_ATTEMPTS=2
for ((ATTEMPT = 1; ATTEMPT <= MAX_ATTEMPTS; ATTEMPT++)); do
    curl -OL "$DOWNLOAD_URL" && break
    echo "Download attempt $ATTEMPT failed. Retrying in 2 seconds..."
    sleep 2
done

# Check if the JetBrainsMono folder exists and delete it if it does
if [ -d $HOME/.local/share/fonts/JetBrainsMonoNerd ]; then
    rm -rf $HOME/.local/share/fonts/JetBrainsMonoNerd
fi

ensure_directories "$HOME/.local/share/fonts/JetBrainsMonoNerd"
# Extract the new files into the JetBrainsMono folder and log the output
tar -xJkf JetBrainsMono.tar.xz -C $HOME/.local/share/fonts/JetBrainsMonoNerd

# clean up
if [ -f "JetBrainsMono.tar.xz" ]; then
    rm -r JetBrainsMono.tar.xz
fi

# Update font cache and log the output
if ! command -v fc-cache &>/dev/null; then
    is_package_installed "fontconfig" || install_package "fontconfig"
fi

log "INFO" "Updating font cache"
fc-cache
