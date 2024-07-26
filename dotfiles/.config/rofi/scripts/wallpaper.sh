#!/usr/bin/env bash

wallDIR="${HOME}/Pictures/wallpapers/"
FPS=60
TYPE="any"
DURATION=2
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

main() {
  choice=$(fd . "${wallDIR}" | xargs basename -a | rofi -i -show -dmenu)

  if [[ -n $choice ]]; then
    swww img "$wallDIR$choice" $SWWW_PARAMS
  else
    echo "Image not found."
    exit 1
  fi
}

main
