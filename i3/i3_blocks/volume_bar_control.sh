#!/bin/bash

CONTROL="$HOME/.config/i3/volume_control.sh"
STATUS="$HOME/.config/i3blocks/volume_status.sh"

case "$BLOCK_BUTTON" in
    1) "$CONTROL" mute ;;
    4) "$CONTROL" up ;;
    5) "$CONTROL" down ;;
esac

# update the volume display
exec "$STATUS"
