#!/bin/bash
DEVICE="asus::kbd_backlight"
MAX_BRIGHTNESS=$(brightnessctl -d $DEVICE max)
CURRENT_BRIGHTNESS=$(brightnessctl -d $DEVICE get)
LEVELS=(0 1 2 3)

CURRENT_INDEX=-1
for i in "${!LEVELS[@]}"; do
   if [[ "${LEVELS[$i]}" == "$CURRENT_BRIGHTNESS" ]]; then
       CURRENT_INDEX=$i
       break
   fi
done

NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#LEVELS[@]} ))
NEXT_LEVEL=${LEVELS[$NEXT_INDEX]}
brightnessctl -d $DEVICE set $NEXT_LEVEL
