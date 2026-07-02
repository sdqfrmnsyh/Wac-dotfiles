#!/bin/sh
xrandr --output eDP --off
xrandr --fb 1920x1080
xrandr --output HDMI-A-0 --set "max bpc" 10
xrandr --output HDMI-A-0 --mode 1920x1080 --pos 0x0 --scale 1x1
