#!/usr/bin/env bash

STATUS=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

if [ "$1" = "icon" ]; then
    [ "$STATUS" = "yes" ] && echo "󰂯" || echo "󰂲"

elif [ "$1" = "text" ]; then
    [ "$STATUS" = "yes" ] && echo "On" || echo "Off"

elif [ "$1" = "list" ]; then
    if [ "$STATUS" != "yes" ]; then
        echo '(box :orientation "v" (label :text "Bluetooth is Disabled" :class "menu-title"))'
        exit 0
    fi

    LITERAL='(box :orientation "v" :space-evenly false :spacing 4 '

    # Scan button
    LITERAL+='(box :orientation "h" :space-evenly true :spacing 4 '
    LITERAL+="(button :class \"list-item-btn\" :onclick \"scripts/bluetooth.sh scan\" \"󰂰 Scan for Devices\")"
    LITERAL+=')'

    # Paired devices
    LITERAL+='(label :class "menu-title" :halign "start" :margin-top 10 :text "Paired Devices")'

    while read -r _ mac name; do
        if [ -n "$mac" ]; then
            if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
                LITERAL+="(button :class \"list-item-btn connected\" :onclick \"scripts/bluetooth.sh disconnect $mac\" \"󰄬 $name\")"
            else
                LITERAL+="(button :class \"list-item-btn\" :onclick \"scripts/bluetooth.sh connect $mac\" \"󰦡 $name\")"
            fi
        fi
    done < <(bluetoothctl devices Paired | head -n 5)

    # Available devices
    LITERAL+='(label :class "menu-title" :halign "start" :margin-top 10 :text "Available Devices")'

    PAIRED_MACS=$(bluetoothctl devices Paired | awk '{print $2}')

    while read -r _ mac name; do
        if [ -n "$mac" ] && ! grep -qx "$mac" <<< "$PAIRED_MACS"; then
            LITERAL+="(button :class \"list-item-btn\" :onclick \"scripts/bluetooth.sh pair $mac\" \"󰂰 $name\")"
        fi
    done < <(bluetoothctl devices | head -n 20)

    LITERAL+=')'
    echo "$LITERAL"

elif [ "$1" = "connect" ]; then
    bluetoothctl connect "$2"

elif [ "$1" = "disconnect" ]; then
    bluetoothctl disconnect "$2"

elif [ "$1" = "pair" ]; then
    bluetoothctl agent on
    bluetoothctl default-agent
    bluetoothctl pair "$2"
    bluetoothctl trust "$2"
    bluetoothctl connect "$2"

elif [ "$1" = "scan" ]; then
    timeout 20s bash -c 'bluetoothctl scan on >/dev/null 2>&1'
fi