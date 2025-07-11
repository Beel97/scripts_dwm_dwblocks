#!/bin/bash
# docker-containers.sh
TITLE="float-alacritty"
COLUMNS=120
LINES=30
SCREEN_WIDTH=$(xdpyinfo | awk '/dimensions/{print $2}' | cut -d'x' -f1)
TERM_WIDTH=$((COLUMNS * 8)) # Ajusta según tu fuente, 8px es estándar
XPOS=$((SCREEN_WIDTH - TERM_WIDTH))
YPOS=30

count=$(docker ps --filter "status=running" --format '{{.ID}}' | wc -l)

case $BLOCK_BUTTON in
1)
  alacritty --title "$TITLE" -o window.dimensions.columns=$COLUMNS -o window.dimensions.lines=$LINES -e lazydocker
  WIN_ID=$(xdotool search --name "$TITLE" | head -n 1)
  if [[ -n "$WIN_ID" ]]; then
    xdotool windowmove "$WIN_ID" "$XPOS" "$YPOS"
  fi
  ;;
2)
  notify-send "Running Docker Containers" "$count running containers" -i docker --expire-time=3000
  ;;
esac

# Ícono Docker (Nerd Font)
icon=""

echo "$icon $count"
