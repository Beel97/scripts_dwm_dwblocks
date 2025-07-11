#!/bin/bash

ICON_RAM=""
ICON_FIRE=""

# Extrae valores en kB directamente con nombres
total_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
available_kb=$(grep MemAvailable /proc/meminfo | awk '{print $2}')

# Calcula memoria usada
used_kb=$((total_kb - available_kb))

# Calcula uso en porcentaje
usage_percent=$((used_kb * 100 / total_kb))

# Convierte uso a GB
used_gb=$(echo "scale=2; $used_kb/1024/1024" | bc)

# Escoge el ícono
if [ "$usage_percent" -gt 70 ]; then
  icon=$ICON_FIRE
else
  icon=$ICON_RAM
fi

echo "$icon ${used_gb}G"
