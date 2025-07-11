#!/bin/bash

batt_path="/sys/class/power_supply/BAT1"
status=$(cat "$batt_path/status")
level=$(cat "$batt_path/capacity")

# Corazones por nivel
full_hearts=$((level / 20))
rest=$((level % 20))

# Determinar si hay medio corazón (si resto >=10)
half_heart=0
if [ "$rest" -ge 10 ]; then
  half_heart=1
fi

empty_hearts=$((5 - full_hearts - half_heart))

hearts=""

for ((i = 0; i < full_hearts; i++)); do
  hearts+="♥"
done

if [ "$half_heart" -eq 1 ]; then
  hearts+="❥" # medio corazón simbólico
fi

for ((i = 0; i < empty_hearts; i++)); do
  hearts+="♡"
done

# Añadir rayo si está cargando o batería llena
if [[ "$status" == "Charging" || "$status" == "Full" ]]; then
  echo "$hearts $level%⚡"
else
  echo "$hearts $level%"
fi
