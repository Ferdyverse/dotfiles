#!/bin/bash

# Define the version files
VERSION_FILES=('version.txt' '.properties.version')
UPDATED=false

# Loop through version files
for FILE in "${VERSION_FILES[@]}"; do
    if [ -f "$FILE" ]; then
        VERSION_FILE=$FILE

        # Print current file being checked
        printf "Checking %s\n" "$FILE"

        # Read the current version
        CURRENT_VERSION=$(cat "$VERSION_FILE")

        # Increment the version (assuming format MAJOR.MINOR.PATCH)
        IFS='.' read -r major minor patch <<<"$CURRENT_VERSION"
        patch=$((patch + 1))
        NEW_VERSION="$major.$minor.$patch"

        # Write the new version to the file
        echo "$NEW_VERSION" >"$VERSION_FILE"

        # Add the updated version file to the staging area
        git add "$VERSION_FILE"

        # Print the updated version information
        printf "🚀 Version in %s has been automatically updated to %s\n" "$VERSION_FILE" "$NEW_VERSION"

        UPDATED=true
    fi
done

# Check if any version file was updated
if [ "$UPDATED" = false ]; then
    exit 1
fi
