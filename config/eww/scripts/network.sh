#!/usr/bin/env bash

if [ "$1" = "icon" ]; then
    [ "$(nmcli radio wifi)" = "enabled" ] && echo "󰖩" || echo "󰖪"

elif [ "$1" = "ssid" ]; then
    NAME=$(nmcli -t -e yes -f ACTIVE,SSID dev wifi | grep '^yes:' | cut -d: -f2-)
    echo "${NAME:-Disconnected}"

elif [ "$1" = "list" ]; then
    if [ "$(nmcli radio wifi)" != "enabled" ]; then
        echo '(box :orientation "v" (label :text "Wi-Fi is Disabled" :class "menu-title"))'
        exit 0
    fi

    LITERAL='(box :orientation "v" :space-evenly false :spacing 4 '

    while IFS=: read -r active ssid signal; do
        [ -z "$ssid" ] && continue

        if [ "$active" = "yes" ]; then
            LITERAL+="
            (button
                :class \"list-item-btn connected\"
                :onclick \"nmcli device disconnect wlan0\"
                \"󰄬 $ssid ($signal%)\")"
        else
            LITERAL+="
            (button
                :class \"list-item-btn\"
                :onclick \"$HOME/.config/eww/scripts/network.sh connect '$ssid'\"
                \"$ssid ($signal%)\")"
        fi

    done < <(
        nmcli -t -e yes -f ACTIVE,SSID,SIGNAL dev wifi |
        awk -F: '!seen[$2]++'
    )

    LITERAL+=')'
    echo "$LITERAL"

elif [ "$1" = "connect" ]; then
    SSID="$2"

    # 1. Check if a profile exists
    # 2. Check if that profile actually has a saved password (PSK)
    SAVED_PSK=$(nmcli -s -g 802-11-wireless-security.psk connection show "$SSID" 2>/dev/null)

    if [ -n "$SAVED_PSK" ]; then
        # Profile exists AND has a password
        nmcli connection up "$SSID"
    else
        # Profile is missing OR is a "dead" profile with no password
        # We delete the empty profile first to ensure a clean prompt
        nmcli connection delete "$SSID" >/dev/null 2>&1
        
        kitty --title "Wi-Fi Password Prompt" \
            -e nmcli device wifi connect "$SSID" --ask
    fi
fi