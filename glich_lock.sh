#!/usr/bin/env bash

IMG_ORIG="/tmp/lock-orig.png"
IMG_GLITCH="/tmp/lock-glitch.png"

# Cargar colores en array
mapfile -t colors <~/.cache/wal/colors

# Captura de pantalla
import -window root "$IMG_ORIG"

# Glitch moderado con ffmpeg
ffmpeg -y -i "$IMG_ORIG" -vf \
  "chromashift=cbh=-4:crh=4, \
 eq=contrast=1.2:brightness=0.01:saturation=2, \
 noise=alls=30:allf=t+u, \
 hue=h=0" \
  -frames:v 1 "$IMG_GLITCH"

# Lock screen con colores de wal
i3lock \
  --image="$IMG_GLITCH" \
  --clock \
  --indicator \
  --radius=170 \
  --ring-width=0 --ring-color="${colors[5]}" \
  --inside-color="${colors[0]}" \
  --line-color=00000000 \
  --keyhl-color="${colors[3]}" \
  --bshl-color="${colors[1]}" \
  --separator-color=00000000 \
  --time-color="${colors[7]}" \
  --date-color="${colors[7]}" \
  --verif-color="${colors[4]}" \
  --insidever-color="${colors[0]}" \
  --ringver-color="${colors[4]}" \
  --wrong-color="${colors[1]}" \
  --insidewrong-color="${colors[0]}" \
  --ringwrong-color="${colors[1]}" \
  --show-failed-attempts
