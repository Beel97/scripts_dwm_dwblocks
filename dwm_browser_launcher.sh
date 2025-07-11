#!/bin/bash

# Directorio donde están las sesiones .yml de qutebrowser
session_dir="$HOME/.local/share/qutebrowser/sessions"

# Verificamos que exista
if [ ! -d "$session_dir" ]; then
  notify-send "Qutebrowser" "No se encontró el directorio de sesiones: $session_dir"
  exit 1
fi

# Listar archivos .yml sin la extensión
sessions=$(find "$session_dir" -type f -name "*.yml" -exec basename {} .yml \;)

# Validar que haya sesiones
if [ -z "$sessions" ]; then
  notify-send "Qutebrowser" "No hay sesiones .yml guardadas."
  exit 1
fi

# Mostrar el menú
selected=$(echo "$sessions" | rofi -dmenu -p "Sesión Qutebrowser")

# Si no seleccionó nada, salir
[ -z "$selected" ] && exit 0

# Lanzar qutebrowser con la sesión elegida
qutebrowser --restore "$selected"
