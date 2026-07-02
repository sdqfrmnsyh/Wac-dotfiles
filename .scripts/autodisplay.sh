#!/bin/bash

HDMI="HDMI-A-0"
EDP="eDP"

# cek apakah HDMI sedang pakai mode aktif (*)
if xrandr | grep "^$HDMI" | grep "\*" > /dev/null; then

    # TV aktif → pakai HDMI sebagai primary
    xrandr --output "$EDP" --off
    xrandr --output "$HDMI" --set "max bpc" 8
    xrandr --output "$HDMI" --mode 1280x720 --primary --pos 0x0 --scale 1x1

else

    # TV mati → fallback ke laptop
    xrandr --output "$HDMI" --off
    xrandr --output "$EDP" --mode 1280x720 --primary --pos 0x0 --scale 1x1

fi
