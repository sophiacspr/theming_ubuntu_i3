#!/bin/bash

SINK=$(pactl get-default-sink)

# Handle mouse scroll and click
case "$BLOCK_BUTTON" in
    1) pactl set-sink-mute "$SINK" toggle ;; # 1 = click: mute/unmute
    4) pactl set-sink-volume "$SINK" +5% ;;  # 4 = scroll up: increase volume
    5) pactl set-sink-volume "$SINK" -5% ;;  # 5 = scroll down: decrease volume
esac

# Get current volume
volume=$(pactl get-sink-volume "$SINK" | grep -oP '\d+%' | head -1 | tr -d '%')
mute=$(pactl get-sink-mute "$SINK" | awk '{print $2}')

# Pad volume display for alignment of the bar with empty spaces
if [ "$volume" -lt 10 ]; then
    volume="  $volume"
elif [ "$volume" -lt 100 ]; then
    volume=" $volume"
fi

# Display current volume
if [ "$mute" == "yes" ]; then
    echo "$volume%🔇"
else
    echo "$volume%🔊"
fi
