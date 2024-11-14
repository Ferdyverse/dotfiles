#!/bin/bash

VERSION_FILE="version.txt"

# Check if the version file exists
if [ ! -f "$VERSION_FILE" ]; then
    echo "⚠️  Version file not found, skipping version increment."
    exit 0
fi

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

echo "🚀 Version has been automatically updated to ${NEW_VERSION}"
