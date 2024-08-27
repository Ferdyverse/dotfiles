if ! is_package_installed "obsidian"; then
    cd /tmp
    release_url=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest  | grep '"browser_download_url":' | grep 'amd64.deb' | grep -vE '(\.pem|\.sig)' | grep -o 'https://[^"]*')
    wget -L $release_url -O obsidian.deb
    sudo apt-get -qq install -y ./obsidian.deb
    rm obsidian.deb
    cd - 
fi