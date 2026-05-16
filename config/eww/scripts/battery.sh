#!/usr/bin/env bash

get_capacity() {
    cat /sys/class/power_supply/BAT0/capacity
}

get_status() {
    cat /sys/class/power_supply/BAT0/status
}

get_icon() {
    CAPACITY=$(get_capacity)
    STATUS=$(get_status)

    if [ "$STATUS" = "Charging" ]; then
        echo "󰂄"
        exit 0
    fi

    if [ "$CAPACITY" -ge 90 ]; then echo "󰁹"
    elif [ "$CAPACITY" -ge 80 ]; then echo "󰂂"
    elif [ "$CAPACITY" -ge 70 ]; then echo "󰂁"
    elif [ "$CAPACITY" -ge 60 ]; then echo "󰂀"
    elif [ "$CAPACITY" -ge 50 ]; then echo "󰁿"
    elif [ "$CAPACITY" -ge 40 ]; then echo "󰁾"
    elif [ "$CAPACITY" -ge 30 ]; then echo "󰁽"
    elif [ "$CAPACITY" -ge 20 ]; then echo "󰁼"
    elif [ "$CAPACITY" -ge 10 ]; then echo "󰁻"
    else echo "󰁺"
    fi
}

get_time() {
    TIME=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "time to empty|time to full" | awk '{print $4, $5}')
    if [ -z "$TIME" ]; then
        STATUS=$(get_status)
        if [ "$STATUS" = "Full" ]; then
            echo "Full"
        else
            echo ""
        fi
    else
        # hours -> h, minutes -> m
        echo "$TIME" | sed 's/ hours/h/g; s/ hour/h/g; s/ minutes/m/g; s/ minute/m/g'
    fi
}

if [ "$1" = "icon" ]; then
    get_icon
elif [ "$1" = "percent" ]; then
    get_capacity
elif [ "$1" = "time" ]; then
    get_time
else
    ICON=$(get_icon)
    PERCENT=$(get_capacity)
    TIME=$(get_time)
    if [ -n "$TIME" ]; then
        echo "$ICON $PERCENT% ($TIME remaining)"
    else
        echo "$ICON $PERCENT%"
    fi
fi
