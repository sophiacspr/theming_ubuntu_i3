#!/bin/bash

# First snapshot of /proc/stat
read cpu user nice system idle iowait irq softirq steal guest < /proc/stat
total=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle_all=$((idle + iowait))

# wait a short interval
sleep 0.5

# Second snapshot of /proc/stat
read cpu2 user2 nice2 system2 idle2 iowait2 irq2 softirq2 steal2 guest2 < /proc/stat
total2=$((user2 + nice2 + system2 + idle2 + iowait2 + irq2 + softirq2 + steal2))
idle_all2=$((idle2 + iowait2))

# Differences between the two snapshots divided by the total time
total_diff=$((total2 - total))
idle_diff=$((idle2 - idle))
usage=$(( (100 * (total_diff - idle_diff)) / total_diff ))

# Pad usage to at least two digits 
printf -v usage "%2d" "$usage"

# Final output
echo "CPU: ${usage}%"

# Open System Monitor
case "$BLOCK_BUTTON" in
    1) gnome-system-monitor & ;;
esac


