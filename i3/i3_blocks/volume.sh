#!/bin/bash


# PIPEWIRE VERSION
SINK="@DEFAULT_AUDIO_SINK@"

case "$BLOCK_BUTTON" in
    1) wpctl set-mute "$SINK" toggle ;;
    4) wpctl set-volume "$SINK" 5%+ ;;
    5) wpctl set-volume "$SINK" 5%- ;;
esac

VOL_RAW=$(wpctl get-volume "$SINK")

# Fallback if no sink is available
if [ -z "$VOL_RAW" ]; then
    echo "--%🔈"
    exit 0
fi

MUTE=no
echo "$VOL_RAW" | grep -q MUTED && MUTE=yes

VOL=$(echo "$VOL_RAW" | awk '{ printf "%d", $2 * 100 }')

if [ "$VOL" -lt 10 ]; then
    VOL="  $VOL"
elif [ "$VOL" -lt 100 ]; then
    VOL=" $VOL"
fi

if [ "$MUTE" = yes ]; then
    echo "${VOL}%🔇"
else
    echo "${VOL}%🔊"
fi




# 
# # PACTL VERSION
# SINK=$(pactl get-default-sink)
# 
# # Handle mouse scroll and click
# case "$BLOCK_BUTTON" in
#     1) pactl set-sink-mute "$SINK" toggle ;; # 1 = click: mute/unmute
#     4) pactl set-sink-volume "$SINK" +5% ;;  # 4 = scroll up: increase volume
#     5) pactl set-sink-volume "$SINK" -5% ;;  # 5 = scroll down: decrease volume
# esac
# 
# # Get current volume
# volume=$(pactl get-sink-volume "$SINK" | grep -oP '\d+%' | head -1 | tr -d '%')
# mute=$(pactl get-sink-mute "$SINK" | awk '{print $2}')
# 
# # Pad volume display for alignment of the bar with empty spaces
# if [ "$volume" -lt 10 ]; then
#     volume="  $volume"
# elif [ "$volume" -lt 100 ]; then
#     volume=" $volume"
# fi
# 
# # Display current volume
# if [ "$mute" == "yes" ]; then
#     echo "$volume%🔇"
# else
#     echo "$volume%🔊"
# fi

