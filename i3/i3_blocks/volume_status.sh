#!/bin/bash

# volume status display for i3blocks
# pipewire version
SINK='@DEFAULT_AUDIO_SINK@'

VOL_RAW=$(wpctl get-volume "$SINK" 2>/dev/null)

# fallback if no sink found
if [ -z "$VOL_RAW" ]; then
    echo "--%🔈"
    exit 0
fi

# check if muted
MUTE=no
echo "$VOL_RAW" | grep -q MUTED && MUTE=yes

VOL=$(echo "$VOL_RAW" | awk '{ printf "%d", $2 * 100 }')

# format volume with padding
if [ "$VOL" -lt 10 ]; then
    VOL="  $VOL"
elif [ "$VOL" -lt 100 ]; then
    VOL=" $VOL"
fi

# display volume and mute status
if [ "$MUTE" = yes ]; then
    echo "${VOL}%🔇"
else
    echo "${VOL}%🔊"
fi

exit 0



