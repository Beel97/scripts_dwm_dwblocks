#!/bin/bash

# Obtener estado del volumen
volume=$(amixer get Master | grep -o '[0-9]*%' | head -n1)
muted=$(amixer get Master | grep -o '\[off\]' | head -n1)

# Elegir icono según estado con Nerd Fonts
if [ -n "$muted" ] || [ "$volume" == "0%" ]; then
  echo "婢 $volume" # nf-oct: mute (oct-mute)
elif [ "${volume%\%}" -lt 30 ]; then
  echo " $volume" # nf-fa: volume-off (fa-volume-off)
elif [ "${volume%\%}" -lt 70 ]; then
  echo " $volume" # nf-fa: volume-down (fa-volume-down)
else
  echo " $volume" # nf-fa: volume-up (fa-volume-up)
fi
