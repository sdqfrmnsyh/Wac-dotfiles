#!/usr/bin/env sh

BAT_PATH="/sys/class/power_supply/BAT0"

if [ -r "$BAT_PATH/capacity" ]; then
    CAP=$(cat "$BAT_PATH/capacity")
    STATUS=$(cat "$BAT_PATH/status")
    ICON='󰁹'
    [ "$CAP" -le 70 ] && ICON='󰂀'
    [ "$CAP" -le 50 ] && ICON='󰁾'
    [ "$CAP" -le 20 ] && ICON='󰁼'
    [ "$CAP" -le 0 ] && ICON='󰁺'
    if [ "$STATUS" = "Charging" ]; then
        FRAMES="󰢜 󰂇 󰢝 󰂉 󰂅"
        FRAME=$(($(date +%s) % 5 + 1))
        ICON=$(echo $FRAMES | cut -d' ' -f$FRAME)
    fi
else
    ICON='󰁺'
    CAP='N/A'
    STATUS="Unknown"
fi

case "$1" in
    icon) echo "$ICON" ;;
    status) echo "${CAP}% ($STATUS)" ;;
esac
