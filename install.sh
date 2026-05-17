#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${1:-$HOME/dots}"
CONFIG="$HOME/.config"
SCRIPTS="$HOME/.local/scripts"

# --- 1. Package List ---
# Categorized from your installed packages list
PACKAGES=(
    # Hyprland Core & Wayland Essentials
    hyprland hyprpaper hyprlock hypridle hyprcursor xdg-desktop-portal-hyprland
    waybar wofi mako kitty wl-clipboard grim slurp

    # Theming & Visuals
    nwg-look qt5-wayland qt6-wayland
    adwaita-icon-theme catppuccin-gtk-theme-mocha
    ttf-jetbrains-mono-nerd ttf-firacode-nerd

    # Shell & CLI Rice
    zsh zsh-autosuggestions zsh-syntax-highlighting
    starship fastfetch btop

    # Utilities & Control
    brightnessctl playerctl pavucontrol
    bluez bluez-utils bluetui
    networkmanager nautilus gvfs
)

echo "Checking for missing packages..."
# Install using yay (handles both repo and AUR packages)
if command -v yay &> /dev/null; then
    yay -S --needed --noconfirm "${PACKAGES[@]}"
else
    sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"
fi

# --- 2. Create Directories ---
mkdir -p "$CONFIG" "$SCRIPTS"

# --- 3. Link Zsh ---
echo "Linking zshrc..."
[ -e "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
ln -sfn "$DOTFILES/.zshrc" "$HOME/.zshrc"

# --- 4. Link Config Folders ---
echo "Linking config files..."
for item in "$DOTFILES/config"/*; do
    [ -e "$item" ] || continue
    name=$(basename "$item")
    target="$CONFIG/$name"
    ln -sfn "$item" "$target"
done

# --- 5. Link Scripts ---
if [ -d "$DOTFILES/scripts" ]; then
    echo "Linking scripts..."
    for script in "$DOTFILES/scripts"/*; do
        [ -f "$script" ] || continue
        name=$(basename "$script")
        target="$SCRIPTS/$name"
        chmod +x "$script"
        ln -sfn "$script" "$target"
    done
fi

echo "Rice installation complete!"