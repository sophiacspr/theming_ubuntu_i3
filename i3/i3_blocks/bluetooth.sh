#!/bin/bash

# click opens Bluetooth settings using blueman manager
if [ "$BLOCK_BUTTON" == "1" ]; then
	setsid blueman-manager >/dev/null 2>&1 &
fi

# get power status
power_status=$(bluetoothctl show | awk '/Powered:/ {print $2}')

# check power on
if [ "$power_status" != "yes" ]; then
    echo "Bluetooth: Off"
    # only proceed if bluetooth is on
    exit 0
fi

# get connected devices (using bluetoothctl and parsing names)
connected_devices=$(bluetoothctl devices Connected | cut -d ' ' -f 3-)

# display that bluetooth is on if no connections, otherwise display devices
if [ -z "$connected_devices" ]; then
    echo "Bluetooth: On"
else
    echo "Bluetooth: $connected_devices"
fi
