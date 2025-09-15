#!/bin/bash

# Touchpad-ID dynamisch holen
id=$(xinput list | grep -i 'touchpad' | grep -o 'id=[0-9]*' | cut -d= -f2)

# Natural Scrolling aktivieren
xinput set-prop "$id" "libinput Natural Scrolling Enabled" 1

# Button-Map setzen (Middle Click deaktivieren)
xinput set-button-map "$id" 1 0 3

# Tap-to-Click aktivieren
xinput set-prop "$id" "libinput Tapping Enabled" 1
