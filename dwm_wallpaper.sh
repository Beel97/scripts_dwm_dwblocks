#!/usr/bin/env bash

CLASS_NAME="WallSelect"
TITLE="float-alacritty"
COLUMNS=120
LINES=21

# Calcular posición superior derecha con margen
SCREEN_WIDTH=$(xdpyinfo | awk '/dimensions/{print $2}' | cut -d'x' -f1)
TERM_WIDTH=$((COLUMNS * 8)) # Ajusta según tu fuente, 8px es estándar
XPOS=$((SCREEN_WIDTH - TERM_WIDTH))
YPOS=30

# Lanzar alacritty flotante con el script integrado
alacritty \
  --class "$CLASS_NAME" \
  --title "$TITLE" \
  -o window.dimensions.columns=$COLUMNS \
  -o window.dimensions.lines=$LINES \
  -e bash -c "
    DIR=\"\$HOME/Pictures/wallpapers\"
    readarray -d '' FILES < <(find \"\$DIR\" -type f \( -iname '*.jpg' -o -iname '*.png' \) -print0 | sort -z)
    SELECTED=\$(printf '%s\n' \"\${FILES[@]}\" | fzf \\
      --height=100% \\
      --preview='chafa --fill=block --symbols=block --size=60x40 {}' \\
      --border=rounded \\
      --color=bg+:-1,bg:-1,spinner:#f5c2e7,hl:#f38ba8 \\
      --delimiter='/' \\
      --with-nth=-1)

    if [[ -n \"\$SELECTED\" ]]; then
      feh --bg-scale \"\$SELECTED\"
      wal -i \"\$SELECTED\"
      pkill dunst && dunst &
      ln -sf ~/.cache/wal/colors.Xresources ~/.Xresources
      cat ~/.Xresources ~/.cache/wal/xrdb_extra | xrdb -merge
      xdotool key super+ctrl+backslash

      if pgrep -x qutebrowser >/dev/null; then
        qutebrowser --target window ':config-source'
      fi
    fi
    read -n 1 -s -r -p 'Presiona cualquier tecla para cerrar...'
  " &

# Esperar un momento y mover con xdotool
sleep 0.3
WIN_ID=$(xdotool search --name "$TITLE" | head -n 1)
if [[ -n "$WIN_ID" ]]; then
  xdotool windowmove "$WIN_ID" "$XPOS" "$YPOS"
fi
