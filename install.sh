#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${1:-$HOME/dots}"
CONFIG="$HOME/.config"
SCRIPTS="$HOME/.local/scripts"

mkdir -p "$CONFIG" "$SCRIPTS"

# zshrc
[ -e "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
ln -sfn "$DOTFILES/.zshrc" "$HOME/.zshrc"

for item in "$DOTFILES/config"/*; do
    [ -e "$item" ] || continue
    name=$(basename "$item")
    target="$CONFIG/$name"

    if [ -e "$target" ] || [ -L "$target" ]; then
        mv "$target" "${target}.bak.$(date +%s)"
    fi

    ln -sfn "$item" "$target"
done

if [ -d "$DOTFILES/scripts" ]; then
    for script in "$DOTFILES/scripts"/*; do
        [ -f "$script" ] || continue
        name=$(basename "$script")
        target="$SCRIPTS/$name"

        if [ -e "$target" ] || [ -L "$target" ]; then
            mv "$target" "${target}.bak.$(date +%s)"
        fi

        ln -sfn "$script" "$target"
    done
fi

echo "done"