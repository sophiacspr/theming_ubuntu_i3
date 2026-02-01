#!/bin/bash


STEP=5
SINK='@DEFAULT_AUDIO_SINK@'

case "$1" in
  up)
    wpctl set-volume "$SINK" ${STEP}%+ || true
    ;;
  down)
    wpctl set-volume "$SINK" ${STEP}%- || true
    ;;
  mute)
    wpctl set-mute "$SINK" toggle || true
    ;;
esac

# inform i3blocks to update volume display
pkill -RTMIN+10 i3blocks || true

exit 0
