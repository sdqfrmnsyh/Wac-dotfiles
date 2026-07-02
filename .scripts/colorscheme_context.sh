#!/bin/bash

SCRIPT="$HOME/.scripts/autocolorscheme.sh"
ID=9991

case "$1" in
    enable)
        if pgrep -x polybar >/dev/null; then
            dunstify -r "$ID" -u normal "WARNING" "You are using ricing mode" -t 2000
            exit 1
        fi

        # Jangan jalankan kalau sudah aktif
        if pgrep -f "$SCRIPT" >/dev/null; then
			dunstify -r "$ID" -u normal "WARNING" "the same process cannot be executed" -t 2000
            exit 0
        fi

        taskset -c 1 nice -n 19 ionice -c3 stdbuf -oL -eL "$SCRIPT" &
        dunstify -r "$ID" -u normal "Auto Color Scheme" "Enabled" -t 2000
        ;;

    disable)
        pkill -f "$SCRIPT"
        dunstify -r "$ID" -u normal "Auto Color Scheme" "Disabled" -t 2000
        ;;

    status)
        if pgrep -f "$SCRIPT" >/dev/null; then
            echo "enabled"
            exit 0
        else
            echo "disabled"
            exit 1
        fi
        ;;

    *)
        echo "Usage: $0 {enable|disable|status}"
        exit 1
        ;;
esac
