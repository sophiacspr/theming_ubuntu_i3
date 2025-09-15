#!/bin/bash

options="Shutdown\nSuspend\nLock\nLogout\nReboot"

chosen=$(echo -e "$options" | rofi -dmenu -p "Power Menu" -theme-str 'window { width: 20%; }')

case "$chosen" in
  Shutdown) systemctl poweroff ;;
  Suspend) systemctl suspend ;;
  Lock) i3lock ;;
  Reboot) systemctl reboot ;;
  Logout) i3-msg exit ;;
esac
