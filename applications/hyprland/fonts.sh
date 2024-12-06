#!/bin/bash

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

# jetbrains nerd font. Necessary for waybar
DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
# Maximum number of download attempts
MAX_ATTEMPTS=2
for ((ATTEMPT = 1; ATTEMPT <= MAX_ATTEMPTS; ATTEMPT++)); do
    curl -OL "$DOWNLOAD_URL" && break
    echo "Download attempt $ATTEMPT failed. Retrying in 2 seconds..."
    sleep 2
done

# Check if the JetBrainsMono folder exists and delete it if it does
if [ -d ~/.local/share/fonts/JetBrainsMonoNerd ]; then
    rm -rf ~/.local/share/fonts/JetBrainsMonoNerd
fi

mkdir -p ~/.local/share/fonts/JetBrainsMonoNerd
# Extract the new files into the JetBrainsMono folder and log the output
tar -xJkf JetBrainsMono.tar.xz -C ~/.local/share/fonts/JetBrainsMonoNerd

# Update font cache and log the output
fc-cache -v

# clean up
if [ -d "JetBrainsMono.tar.xz" ]; then
	rm -r JetBrainsMono.tar.xz
fi
