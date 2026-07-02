#!/bin/bash

SCRIPT="$HOME/.scripts/autocolorscheme.sh"
ID=9991

if pgrep -x polybar > /dev/null; then
dunstify -r $ID -u normal "WARNING" "You are using ricing mode" -t 2000
exit
else

if pgrep autocolorscheme > /dev/null 2>&1; then
        kill $SCRIPT
        pkill $SCRIPT
        pkill -f $SCRIPT
        killall $SCRIPT
        dunstify -r $ID -u normal "Auto Color Scheme" "Disabled" -t 2000
    else
        taskset -c 1 nice -n 19 ionice -c3 stdbuf -oL -eL "$SCRIPT" &
        dunstify -r $ID -u normal "Auto Color Scheme" "Enabled" -t 2000
    fi
fi
