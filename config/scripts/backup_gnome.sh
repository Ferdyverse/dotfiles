#!/bin/bash

DATE=$(date +%Y-%m-%d)
BACKUP_DIR="$HOME/.dotfiles/config/gnome"
EXPORT_FILE="$BACKUP_DIR/gnome-settings-backup_$(hostname)_$DATE.dconf"

# Export GNOME settings
export_gnome_settings() {
    echo "Exporting GNOME settings..."
    dconf dump / > "$EXPORT_FILE"
    echo "GNOME settings exported to $EXPORT_FILE"
}

# List available backup files in the specified directory and present a menu
select_backup_file() {
    local files=("$BACKUP_DIR"/*.dconf)
    if [ ${#files[@]} -eq 0 ]; then
        echo "No backup files found in $BACKUP_DIR"
        return 1
    fi

    echo "Select a backup file to import:"
    select file in "${files[@]}" "Cancel"; do
        case $file in
            Cancel)
                echo "Operation canceled."
                return 1
                ;;
            "")
                echo "Invalid selection. Please choose a number from the list."
                ;;
            *)
                IMPORT_FILE="$file"
                return 0
                ;;
        esac
    done
}

# Import GNOME settings
import_gnome_settings() {
    if [ -z "$IMPORT_FILE" ]; then
        echo "No backup file specified for import!"
        return 1
    elif [ ! -f "$IMPORT_FILE" ]; then
        echo "Backup file $IMPORT_FILE not found!"
        return 1
    fi

    echo "Importing GNOME settings..."
    dconf load / < "$IMPORT_FILE"
    echo "GNOME settings imported from $IMPORT_FILE"
}

# Example usage
case "$1" in
    export)
        export_gnome_settings
        ;;
    import)
        if select_backup_file; then
            import_gnome_settings
        else
            echo "No file selected for import."
        fi
        ;;
    *)
        echo "Usage: $0 {export|import}"
        exit 1
        ;;
esac
