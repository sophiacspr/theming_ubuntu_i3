#!/bin/bash

BAT="/sys/class/power_supply/BAT0"

# find battery
if [ ! -d "$BAT" ]; then
    echo "⚠️"
    exit 1
fi

# get the current powerprofile
profile=$(powerprofilesctl get 2>/dev/null)

# cycle on left click
if [ "$BLOCK_BUTTON" = "1" ]; then
    case "$profile" in
        power-saver)
            powerprofilesctl set balanced
            ;;
        balanced)
            powerprofilesctl set performance
            ;;
        performance)
            powerprofilesctl set power-saver
            ;;
    esac
    profile=$(powerprofilesctl get 2>/dev/null)
fi

# get battery capacity
capacity=$(cat "$BAT/capacity")
status=$(cat "$BAT/status")

# update status
if [ "$status" = "Charging" ]; then
    echo "${capacity}%🔌 (${profile})"
else
    if [ "$capacity" -lt 20 ]; then
        echo "${capacity}%🪫 (${profile})"
    else
        echo "${capacity}%🔋 (${profile})"
    fi
fi
