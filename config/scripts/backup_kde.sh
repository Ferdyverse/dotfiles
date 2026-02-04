#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(pwd)/config/kde"

SRC_CONFIG="$HOME/.config"
SRC_SHARE="$HOME/.local/share"

DST_CONFIG="$DOTFILES_DIR/config"
DST_SHARE="$DOTFILES_DIR/local-share"

echo "▶ Sammle KDE Configs…"

# --- ~/.config ---
KDE_CONFIG_FILES=(
  kdeglobals
  kwinrc
  kglobalshortcutsrc
  krunnerrc
  plasmarc
  plasmashellrc
  dolphinrc
  konsolerc
  plasma-org.kde.plasma.desktop-appletsrc
)

for file in "${KDE_CONFIG_FILES[@]}"; do
  if [[ -f "$SRC_CONFIG/$file" ]]; then
    echo "  ✔ ~/.config/$file"
    cp -a "$SRC_CONFIG/$file" "$DST_CONFIG/"
  else
    echo "  ⚠ fehlt: ~/.config/$file"
  fi
done

# --- ~/.local/share ---
KDE_SHARE_DIRS=(
  konsole
  color-schemes
  kxmlgui6
)

for dir in "${KDE_SHARE_DIRS[@]}"; do
  if [[ -d "$SRC_SHARE/$dir" ]]; then
    echo "  ✔ ~/.local/share/$dir/"
    mkdir -p "$DST_SHARE"
    cp -a "$SRC_SHARE/$dir" "$DST_SHARE/"
  else
    echo "  ⚠ fehlt: ~/.local/share/$dir/"
  fi
done

echo
echo "✅ KDE Konfiguration gesammelt."
echo "   Ziel: $DOTFILES_DIR"
echo
echo "👉 Tipp: Plasma vorher ausloggen, um inkonsistente Files zu vermeiden."
