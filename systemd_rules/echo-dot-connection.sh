#!/usr/bin/env bash
set -e

MAC="D8:FB:D6:74:41:4D"

sleep 8

until wpctl status | grep -q "Sinks:"; do
  sleep 0.3
done

if bluetoothctl connect "$MAC"; then
  SINK_ID=$(wpctl status | grep -i "Echo Dot" | grep -o '[0-9]\+' | head -n1)
else
  SINK_ID=$(wpctl status | grep -i "Speaker" | grep -o '[0-9]\+' | head -n1)
fi

if [ -n "$SINK_ID" ]; then
  wpctl set-default "$SINK_ID"
fi

pkill -RTMIN+10 i3blocks || true
