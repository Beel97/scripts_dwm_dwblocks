#!/usr/bin/env bash

# Opciones del menú con íconos de Nerd Font (requiere fuente compatible)
options="󰌾 Lock\n󰍃 Logout\n󰤄 Suspend\n󰒲 Hibernate\n󰑓 Reboot\n󰐥 Shutdown"

# Ejecuta rofi y guarda la opción seleccionada
chosen=$(echo -e "$options" | rofi -theme ~/.cache/wal/rofi-oneline.rasi -dmenu -i -p "Power Menu:")

case "$chosen" in
"󰌾 Lock")
  if command -v betterlockscreen &>/dev/null; then
    betterlockscreen -l
  elif command -v i3lock &>/dev/null; then
    i3lock
  else
    echo "No lockscreen encontrado." >&2
  fi
  ;;
"󰍃 Logout")
  pkill -KILL -u "$USER"
  ;;
"󰤄 Suspend")
  systemctl suspend
  ;;
"󰒲 Hibernate")
  systemctl hibernate
  ;;
"󰑓 Reboot")
  systemctl reboot
  ;;
"󰐥 Shutdown")
  systemctl poweroff
  ;;
*)
  exit 0
  ;;
esac
