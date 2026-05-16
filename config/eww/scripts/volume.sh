#!/usr/bin/env bash
if [ "$1" = "get" ]; then
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
elif [ "$1" = "icon" ]; then
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED" && echo "󰝟" || echo "󰕾"
fi