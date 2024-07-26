#!/usr/bin/env bash

wallDIR="${HOME}/Pictures/wallpapers/"
FPS=60
TYPE="any"
DURATION=2
#BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"
#PICS=($(fd . "${wallDIR}"))
PICS=($(find "${wallDIR}" -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif \)))
ROFI="rofi -i -show -dmenu"

menu() {
  sorted_options=($(printf '%s\n' "${PICS[@]}" | sort))
  for pic_path in "${sorted_options[@]}"; do
    pic_name=$(basename "$pic_path")
    printf "%s/n" "$pic_name"
  done
}

main() {
  choice=$(menu | ${ROFI})

  pic_index=-1
  for i in "${!PICS[@]}"; do
    filename=$(basename "${PICS[$i]}")
    if [[ "$filename" == "$choice"* ]]; then
      pic_index=$i
      break
    fi
  done

  if [[ $pic_index -ne -1 ]]; then
    swww img -o "${PICS[$pic_index]}" $SWWW_PARAMS
  else
    echo "Image not found."
    exit 1
  fi
}

main

sleep 0.5
