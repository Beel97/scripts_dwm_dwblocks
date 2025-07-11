#!/bin/bash

read cpu user nice system idle iowait irq softirq steal guest </proc/stat
sleep 0.5
read cpu2 user2 nice2 system2 idle2 iowait2 irq2 softirq2 steal2 guest2 </proc/stat

prev_idle=$((idle + iowait))
idle=$((idle2 + iowait2))

prev_non_idle=$((user + nice + system + irq + softirq + steal))
non_idle=$((user2 + nice2 + system2 + irq2 + softirq2 + steal2))

prev_total=$((prev_idle + prev_non_idle))
total=$((idle + non_idle))

totald=$((total - prev_total))
idled=$((idle - prev_idle))

cpu_percentage=$(((1000 * (totald - idled) / totald + 5) / 10))

# Iconos
ICON_CPU="" # Nerd Font icon de CPU (fa-cpu)
ICON_FIRE=""

if [ "$cpu_percentage" -gt 70 ]; then
  icon=$ICON_FIRE
else
  icon=$ICON_CPU
fi

echo "$icon $cpu_percentage%"
