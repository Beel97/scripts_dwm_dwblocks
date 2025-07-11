#!/bin/bash

# Función para verificar si una sesión ya existe (extrae solo el nombre)
session_exists() {
  zellij list-sessions 2>/dev/null | awk '{print $1}' | grep -Fxq "$1"
}

# 1. Selección del proyecto con zoxide
selection=$(zoxide query -l | rofi -dmenu -p "📁 Proyecto → zellij" -i)
[ -z "$selection" ] && exit 0

# 2. Selección del layout
layout=$(ls ~/.config/zellij/layouts/*.kdl 2>/dev/null | xargs -n 1 basename | sed 's/\.kdl$//' | rofi -dmenu -p "🎨 Layout" -i)
[ -z "$layout" ] && exit 0

# 3. Nombre limpio de sesión
#session_name=$(basename "$selection" | tr -cd '[:alnum:]_-')

# 4. Lógica principal
#if session_exists "$session_name"; then
# Si ya existe la sesión, solo adjuntarla
#  alacritty -e zellij attach "$session_name"
#else
#  # Si no existe, crear la sesión con layout en el proyecto
#  alacritty -e bash -c "cd \"$selection\" && zellij --session \"$session_name\" --layout \"$layout\""
#fi

alacritty -e bash -c "cd \"$selection\" && zellij --layout \"$layout\""
