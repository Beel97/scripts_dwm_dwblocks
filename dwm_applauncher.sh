#!/usr/bin/env sh

# Obtener modo desde argumento
case "$1" in
d | --drun) mode="drun" ;;
w | --window) mode="window" ;;
f | --filebrowser) mode="filebrowser" ;; # Solo si tienes rofi-file-browser-extended
*) mode="drun" ;;
esac

# Lanzar rofi en el modo indicado sin estilos personalizados
rofi -theme ~/.cache/wal/rofi-oneline.rasi -show "$mode" --show-icons
