# Add custom nerd fonts

# Define the system font directory
SYSTEM_FONT_DIR="/usr/share/fonts/truetype/custom"

# Function to install fonts from a specified directory
install_fonts_from_directory() {
    local font_dir="$1"

    # Ensure the font directory exists
    if [ ! -d "$font_dir" ]; then
        log "ERROR" "Font directory $font_dir does not exist"
        exit 1
    fi

    ensure_directories $SYSTEM_FONT_DIR 

    # Find all .ttf files in the specified directory
    local font_files=("$font_dir"/*.ttf)
    if [ ${#font_files[@]} -eq 0 ]; then
        log "ERROR" "No .ttf files found in directory $font_dir"
        exit 1
    fi

    for font_file in "${font_files[@]}"; do
        if [ -f "$font_file" ]; then
            log "INFO" "Installing font $font_file to $SYSTEM_FONT_DIR"
            sudo cp "$font_file" "$SYSTEM_FONT_DIR"
            if [ $? -eq 0 ]; then
                log "SUCCESS" "Font $font_file installed successfully"
            else
                log "ERROR" "Failed to install font $font_file"
                exit 1
            fi
        else
            log "ERROR" "Font file $font_file does not exist"
            exit 1
        fi
    done

    # Update font cache
    log "INFO" "Updating font cache"
    log "INFO" "This may take a while..."
    sudo fc-cache -fv 1> /dev/null
    if [ $? -eq 0 ]; then
        log "SUCCESS" "Font cache updated successfully"
    else
        log "ERROR" "Failed to update font cache"
        exit 1
    fi
}

local font_dir="$SCRIPT_DIR/config/fonts/"

# Determine the Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    log "ERROR" "Unknown Linux distribution"
    exit 1
fi

if ! command -v fc-cache &> /dev/null; then
    is_package_installed "fontconfig" || install_package "fontconfig"
fi

install_fonts_from_directory "$font_dir"
