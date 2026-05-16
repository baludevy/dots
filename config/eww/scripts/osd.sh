#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
TYPE=$1
ACTION=$2

case $TYPE in
    volume)
        case $ACTION in
            up) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ ;;
            down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
            mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
        esac
        VAL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}' | cut -d. -f1)
        ICON=$("$SCRIPT_DIR/volume.sh" icon)
        eww update osd_icon="$ICON" osd_value="$VAL" osd_title="Volume"
        ;;
    brightness)
        case $ACTION in
            up) brightnessctl set 5%+ ;;
            down) brightnessctl set 5%- ;;
        esac
        VAL=$("$SCRIPT_DIR/brightness.sh")
        ICON="󰃠"
        eww update osd_icon="$ICON" osd_value="$VAL" osd_title="Brightness"
        ;;
esac

eww open osd
sleep 2
eww close osd
