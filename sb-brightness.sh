#!/bin/bash

# Obtener brillo actual y máximo
current=$(brightnessctl get)
max=$(brightnessctl max)

# Calcular porcentaje
percent=$((100 * current / max))

# Elegir icono según nivel de brillo (Nerd Fonts)
if [ "$percent" -lt 30 ]; then
  icon="" # nf-mdi: brightness-low
elif [ "$percent" -lt 70 ]; then
  icon="" # nf-mdi: brightness-medium
else
  icon="" # nf-mdi: brightness-high
fi

echo "$icon ${percent}%"
