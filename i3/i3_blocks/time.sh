#!/bin/bash

# open google calendar on click from default browser
case "$BLOCK_BUTTON" in
    1) xdg-open "https://calendar.google.com" >/dev/null 2>&1 & ;;
esac

# print the formatted day, date and time
date '+%a %d-%m-%Y %H:%M'
