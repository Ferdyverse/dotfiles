# Install/apply KDE basic tools and config

if $RUNNING_KDE; then
    log "INFO" "Applying KDE basic config"

    ensure_directories "$HOME/.config" "$HOME/.local/share"

    kde_config_files=(
        kdeglobals
        kwinrc
        kwinoutputconfig.json
        kglobalshortcutsrc
        krunnerrc
        plasmarc
        plasmashellrc
        dolphinrc
        konsolerc
        plasma-org.kde.plasma.desktop-appletsrc
        kscreenlockerrc
        powerdevilrc
        powermanagementprofilesrc
        kactivitymanagerdrc
        kactivitymanagerd-statsrc
        ksmserverrc
        plasmanotifyrc
        plasma-localerc
        spectaclerc
        discoverrc
    )

    # Support host-specific kwinrc files, e.g. kwinrc.Otto or kwinrc.otto
    host_lower="$(echo "$HOSTNAME" | tr '[:upper:]' '[:lower:]')"

    resolve_host_config() {
        local base_name="$1"
        local local_file="$2"
        local label="$3"
        local extension="${4:-}"
        local selected=""
        local candidate=""

        for candidate in "${base_name}.${HOSTNAME}${extension}" "${base_name}.${host_lower}${extension}"; do
            if [[ -f "$SCRIPT_DIR/config/kde/config/$candidate" ]]; then
                selected="$candidate"
                break
            fi
        done

        if [[ -z "$selected" && -f "$local_file" ]]; then
            selected="${base_name}.${HOSTNAME}${extension}"
            cp -a "$local_file" "$SCRIPT_DIR/config/kde/config/$selected"
            log "INFO" "Created host-specific ${label} config: $selected"
        fi

        echo "$selected"
    }

    selected_kwinrc="$(resolve_host_config "kwinrc" "$HOME/.config/kwinrc" "KWin")"
    selected_kwinoutput="$(resolve_host_config "kwinoutputconfig" "$HOME/.config/kwinoutputconfig.json" "output" ".json")"
    selected_powerdevil="$(resolve_host_config "powerdevilrc" "$HOME/.config/powerdevilrc" "power")"
    selected_powermanagement="$(resolve_host_config "powermanagementprofilesrc" "$HOME/.config/powermanagementprofilesrc" "power profile")"
    selected_appletsrc="$(resolve_host_config "plasma-org.kde.plasma.desktop-appletsrc" "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" "Plasma layout")"

    for file in "${kde_config_files[@]}"; do
        src_file="$SCRIPT_DIR/config/kde/config/$file"

        case "$file" in
            kwinrc)
                [[ -n "$selected_kwinrc" ]] && src_file="$SCRIPT_DIR/config/kde/config/$selected_kwinrc"
                ;;
            kwinoutputconfig.json)
                [[ -n "$selected_kwinoutput" ]] && src_file="$SCRIPT_DIR/config/kde/config/$selected_kwinoutput"
                ;;
            powerdevilrc)
                [[ -n "$selected_powerdevil" ]] && src_file="$SCRIPT_DIR/config/kde/config/$selected_powerdevil"
                ;;
            powermanagementprofilesrc)
                [[ -n "$selected_powermanagement" ]] && src_file="$SCRIPT_DIR/config/kde/config/$selected_powermanagement"
                ;;
            plasma-org.kde.plasma.desktop-appletsrc)
                [[ -n "$selected_appletsrc" ]] && src_file="$SCRIPT_DIR/config/kde/config/$selected_appletsrc"
                ;;
        esac

        if [[ -f "$src_file" ]]; then
            create_symlink "$src_file" "$HOME/.config/$file"
        else
            log "WARNING" "KDE config file missing: $src_file"
        fi
    done

    kde_share_dirs=(
        konsole
        color-schemes
        kxmlgui6
        kscreen
        plasma
        wallpapers
        icons
        aurorae
        knewstuff3
        kded6
    )

    for dir in "${kde_share_dirs[@]}"; do
        src_dir="$SCRIPT_DIR/config/kde/local-share/$dir"
        dst_dir="$HOME/.local/share/$dir"

        if [[ -d "$src_dir" ]]; then
            create_symlink "$src_dir" "$dst_dir"
        else
            log "DEBUG" "KDE share dir missing: $src_dir"
        fi
    done

    log "SUCCESS" "KDE basic config applied"
    log "INFO" "Log out and back in to ensure all Plasma settings are loaded"
fi
