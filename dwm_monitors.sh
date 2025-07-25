#!/bin/bash

# Detectar salidas
INTERNAL_DISPLAY=$(xrandr | grep " connected primary" | cut -d ' ' -f1)
EXTERNAL_DISPLAYS=$(xrandr | grep " connected" | grep -v "$INTERNAL_DISPLAY" | cut -d ' ' -f1)

# Elegir monitor externo
SELECTED_MONITOR=$(echo "$EXTERNAL_DISPLAYS" | rofi -dmenu -p "Selecciona monitor externo")
[ -z "$SELECTED_MONITOR" ] && exit

# Elegir modo
MODE=$(echo -e "Expandir\nDuplicar\nApagar externo" | rofi -dmenu -p "Modo de pantalla")
[ -z "$MODE" ] && exit

# Apagar monitor externo
if [ "$MODE" = "Apagar externo" ]; then
  xrandr --output "$SELECTED_MONITOR" --off
  notify-send "Monitor" "$SELECTED_MONITOR apagado"
  exit
fi

# Duplicar
if [ "$MODE" = "Duplicar" ]; then
  # Resoluciones comunes
  COMMON_RES=$(echo -e "1024x768\n1280x720\n800x600" | rofi -dmenu -p "Resolución para duplicar")
  [ -z "$COMMON_RES" ] && exit

  xrandr --output "$INTERNAL_DISPLAY" --mode "$COMMON_RES"
  xrandr --output "$SELECTED_MONITOR" --mode "$COMMON_RES" --same-as "$INTERNAL_DISPLAY"
  notify-send "Monitor" "$SELECTED_MONITOR duplicado a $COMMON_RES"
  exit
fi

# Expandir
if [ "$MODE" = "Expandir" ]; then
  SIDE=$(echo -e "izquierda\nderecha\narriba\nabajo" | rofi -dmenu -p "¿Dónde está el monitor?")
  [ -z "$SIDE" ] && exit

  POSITION="--right-of"
  case "$SIDE" in
  izquierda) POSITION="--left-of" ;;
  derecha) POSITION="--right-of" ;;
  arriba) POSITION="--above" ;;
  abajo) POSITION="--below" ;;
  esac

  xrandr --output "$SELECTED_MONITOR" --auto "$POSITION" "$INTERNAL_DISPLAY"
  feh --bg-scale "$(cat ~/.cache/wal/wal)" # o el path directo del último fondo usado
  notify-send "Monitor" "$SELECTED_MONITOR expandido a la $SIDE"
  exit
fi
