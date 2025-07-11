#!/bin/bash

ICON_ETHERNET="󰈁"
ICON_WIFI="󰖩"
ICON_DISCONNECTED="󰖪"
TMPFILE="/tmp/dwmblocks-network-connecting"

notify() {
  notify-send "Red WiFi" "$1"
}

find_saved_profile_for_ssid() {
  for profile in $(nmcli -t -f NAME,TYPE connection show | awk -F: '$2 == "802-11-wireless" {print $1}'); do
    ssid=$(nmcli -f 802-11-wireless.ssid connection show "$profile" 2>/dev/null | awk '{print $2}')
    if [[ "$ssid" == "$1" ]]; then
      echo "$profile"
      return 0
    fi
  done
  return 1
}

handle_click() {
  touch "$TMPFILE"
  mapfile -t lines < <(nmcli -f SSID,SECURITY,SIGNAL,BARS dev wifi list | awk 'NR>1 && $1 != ""' | sort -u)

  options=()
  for line in "${lines[@]}"; do
    ssid=$(echo "$line" | awk '{for (i=1; i<=NF-3; i++) printf $i " "; print ""}' | sed 's/ *$//')
    signal=$(echo "$line" | awk '{print $(NF-1)}')
    secure=$(echo "$line" | awk '{print $(NF-2)}')
    bars=$(echo "$line" | awk '{print $NF}')
    [ -z "$ssid" ] && continue
    label="$ssid [$secure] $bars"
    options+=("$label")
  done

  chosen=$(printf "%s\n" "${options[@]}" | rofi -dmenu -p "WiFi")
  [[ -z "$chosen" ]] && rm -f "$TMPFILE" && exit

  selected_ssid=$(echo "$chosen" | sed 's/ \[.*//')
  notify "Conectando a $selected_ssid..."

  # Buscar perfil real asociado a ese SSID
  profile=$(find_saved_profile_for_ssid "$selected_ssid")
  if [[ -n "$profile" ]]; then
    if nmcli connection up "$profile"; then
      notify "Conectado a $selected_ssid (perfil: $profile)"
    else
      notify "Error al conectar a $selected_ssid (perfil: $profile)"
    fi
    rm -f "$TMPFILE"
    exit
  fi

  # Nueva red (no perfil guardado)
  secure=$(nmcli -t -f SSID,SECURITY dev wifi | grep "^$selected_ssid:" | cut -d: -f2 | head -n1)
  if [[ "$secure" != "" ]]; then
    password=$(rofi -dmenu -password -p "Contraseña para $selected_ssid")
    [[ -z "$password" ]] && notify "Conexión cancelada" && rm -f "$TMPFILE" && exit
    if nmcli dev wifi connect "$selected_ssid" password "$password"; then
      notify "Conectado a $selected_ssid"
    else
      notify "Error al conectar a $selected_ssid"
    fi
  else
    if nmcli dev wifi connect "$selected_ssid"; then
      notify "Conectado a $selected_ssid"
    else
      notify "Error al conectar a $selected_ssid"
    fi
  fi
  rm -f "$TMPFILE"
}

if [[ "$BLOCK_BUTTON" == "1" ]]; then
  handle_click &
  exit
fi

# Mostrar estado
if [[ -f "$TMPFILE" ]]; then
  echo "$ICON_WIFI Conectando..."
  exit
fi

interface_info=$(nmcli -t -f DEVICE,TYPE,STATE,CONNECTION dev status | grep -E ':wifi:connected:|:ethernet:connected:' | head -n1)
IFS=: read -r iface type state conn <<<"$interface_info"

if [[ "$type" == "ethernet" ]]; then
  echo "$ICON_ETHERNET $iface"
elif [[ "$type" == "wifi" ]]; then
  ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
  echo "$ICON_WIFI $ssid"
else
  echo "$ICON_DISCONNECTED Desconectado"
fi
