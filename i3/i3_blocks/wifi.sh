#!/bin/bash

# setup using nm-connection-editor
if [ "$BLOCK_BUTTON" = "1" ]; then
    nm-connection-editor >/dev/null 2>&1 &
fi

# display current connection
essid=$(nmcli -t -f active,ssid dev wifi | awk -F: '$1=="yes"{print $2; exit}')
if [ -z "$essid" ]; then
    echo "Wi-Fi: Disconnected"
else
    safe_essid=$(echo "$essid" | sed 's/\\/\\\\/g; s/"/\\"/g; s/%/%%/g')
    echo "Wi-Fi: $safe_essid"
fi


# alternative setup using rofi network manager to select network to connect to

# if [ "$BLOCK_BUTTON" == "1" ]; then
#     ssids=$(nmcli -t -f SSID dev wifi list | awk 'length' | sort -u)
#     selected=$(echo "$ssids" | rofi -dmenu -p "Connect to Wi-Fi:")
#     if [ -n "$selected" ]; then
#         nmcli device wifi connect "$selected" >/dev/null 2>&1
#     fi
# fi
