#!/bin/bash
# Control y estado de Spotify para dwmblocks
# Requiere: playerctl

case $BLOCK_BUTTON in
1) playerctl play-pause ;;  # click izquierdo → play/pausa
2) playerctl next ;;        # click medio → siguiente
3) playerctl previous ;;    # click derecho → anterior
4) playerctl position 5- ;; # scroll arriba → retrocede 5s
5) playerctl position 5+ ;; # scroll abajo → adelanta 5s
esac

status=$(playerctl status 2>/dev/null)
if [ "$status" = "Playing" ]; then
  icon="▶"
elif [ "$status" = "Paused" ]; then
  icon="⏸"
else
  exit 0 # nada en reproducción
fi

artist=$(playerctl metadata artist 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)

echo "$icon $artist - $title"
