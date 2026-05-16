#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config/waybar"

cleanup() {
    pkill -x waybar 2>/dev/null
    kill "$INOTIFY_PID" 2>/dev/null
    exit
}

trap cleanup SIGINT SIGTERM

inotifywait -m -e create,modify,move,delete -r "$CONFIG_DIR" |
while read -r _; do
    pkill -x waybar 2>/dev/null
    waybar &
done &
INOTIFY_PID=$!

waybar &

wait