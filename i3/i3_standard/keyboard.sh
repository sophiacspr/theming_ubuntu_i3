#!/bin/bash

LOGFILE="/home/sophia/setxkbmap_daemon.log"
exec >>"$LOGFILE" 2>&1
echo "===== $(date): start ====="


# Filter Keyboards: Find lines containing Handlers or Name, keep only those pairs containing ,
keyboard_events=$(grep "Handlers\|Name=" /proc/bus/input/devices \
  | grep -B1 "kbd" | grep -o "event[0-9]\+" | sort -u)

# wenn keine gefunden, beenden
[ -z "$keyboard_events" ] && exit 1

# aktuelle Belegung merken
last_device=""

libinput debug-events $(printf -- "--device /dev/input/%s " $keyboard_events) | \
while read -r line; do

  echo "variant: A"
  # nur Tastendrücke betrachten
  [[ "$line" != *"KEYBOARD_KEY"* || "$line" != *"pressed"* ]] && continue


  # Gerätename holen
  evnode=$(echo "$line" | awk '{print $1}')
  name=$(awk -v ev="$evnode" '
    $0 ~ ev {found=1}
    found && /Name=/ {match($0, /Name="([^"]+)"/, a); print a[1]; exit}
  ' /proc/bus/input/devices)

  # kein Name → überspringen
  [ -z "$name" ] && continue

  # Gerät bestimmen
  if echo "$name" | grep -q "RK84RGB5.0  Keyboard"; then
    device="rk84"
  else
    device="default"
  fi

  # wenn Gerät gleich bleibt → nichts tun
  [ "$device" = "$last_device" ] && continue

  # Layout setzen
  if [ "$device" = "rk84" ]; then
    rk84_id=$(xinput list --id-only 'keyboard:RK84RGB5.0  Keyboard' 2>/dev/null)
    [ -n "$rk84_id" ] && setxkbmap -device "$rk84_id" -layout us -variant alt-intl-unicode -option altwin:swap_lalt_lwin
  else
    setxkbmap -layout us -variant alt-intl-unicode -option lv3:ralt_switch
  fi

  last_device="$device"
done
