#!/bin/bash

# Lista todos los dispositivos conocidos con su estado
devices=$(bluetoothctl devices | awk '{print $2 " " substr($0, index($0,$3))}')
[[ -z "$devices" ]] && notify-send "Bluetooth" "No se encontraron dispositivos" && exit 1

# Construye lista con estado conectado/desconectado
menu=""
while IFS= read -r line; do
  mac=$(echo "$line" | awk '{print $1}')
  name=$(echo "$line" | cut -d' ' -f2-)
  connected=$(bluetoothctl info "$mac" | grep "Connected: yes")
  if [[ -n "$connected" ]]; then
    menu+="󰂱 $name ($mac) [Conectado]\n"
  else
    menu+="󰂯 $name ($mac)\n"
  fi
done <<<"$devices"

# Mostrar con rofi
selection=$(echo -e "$menu" | rofi -dmenu -p "Bluetooth" -theme-str 'window { width: 40%; }')

# Cancelado
[[ -z "$selection" ]] && exit 0

# Extraer MAC
selected_mac=$(echo "$selection" | grep -oP '([A-F0-9]{2}:){5}[A-F0-9]{2}')

# Conectar o desconectar
if [[ "$selection" == *"[Conectado]"* ]]; then
  bluetoothctl disconnect "$selected_mac" >/dev/null
  notify-send "Bluetooth" "Desconectado de $selected_mac"
else
  bluetoothctl connect "$selected_mac" >/dev/null
  notify-send "Bluetooth" "Conectado a $selected_mac"
fi
