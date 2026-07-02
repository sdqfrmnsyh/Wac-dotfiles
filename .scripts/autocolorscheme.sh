#!/bin/bash

SCRIPT="$HOME/.scripts/colorscheme_condition.sh"
PNG="/home/modz/.scripts/hy.png"

STATE="none"
LAST_WALL=""
LAST_VID=""
LAST_PICOM=""

while true; do
    # --- 1. Ambil semua info sekali jalan ---
    XWIN_INFO=$(pgrep -af xwinwrap 2>/dev/null)
    if [ -n "$XWIN_INFO" ]; then
        CURRENT="live"
        CURRENT_VID=$(echo "$XWIN_INFO" | grep -oE '[^ ]+\.(mp4|mkv|webm|gif)' | head -n1 | grep -Ev "hy.png")
    else
        CURRENT="static"
        CURRENT_VID=""
    fi

    pgrep -x picom >/dev/null 2>&1 && PICOM_NOW="on" || PICOM_NOW="off"

    WALL=$(grep -oP "'\K[^']+\.(jpg|jpeg|png|webp)" ~/.fehbg | grep -Ev "hy.png" | head -n1)

    # --- 2. Perubahan state live ↔ static ---
    if [ "$CURRENT" != "$STATE" ]; then
        if [ "$CURRENT" = "live" ]; then
            taskset -c 0 nice -n 19 ionice -c3 stdbuf -oL -eL chrt --idle 0 "$SCRIPT" live
            LAST_VID="$CURRENT_VID"
            feh --bg-fill "$PNG"
        else
            taskset -c 0 nice -n 19 ionice -c3 stdbuf -oL -eL chrt --idle 0 "$SCRIPT" static
            LAST_VID=""
        fi
        STATE="$CURRENT"
        WALL=$(grep -oP "'\K[^']+\.(jpg|jpeg|png|webp)" ~/.fehbg | grep -Ev "hy.png" | head -n1)
        LAST_WALL="$WALL"
        LAST_PICOM="$PICOM_NOW"
        sleep 0.842
        continue
    fi

    # --- 3. Saat live: deteksi ganti video / picom berubah ---
    if [ "$CURRENT" = "live" ] && { [ "$CURRENT_VID" != "$LAST_VID" ] || [ "$PICOM_NOW" != "$LAST_PICOM" ]; }; then
        taskset -c 0 nice -n 19 ionice -c3 stdbuf -oL -eL chrt --idle 0 "$SCRIPT" live
        LAST_VID="$CURRENT_VID"
        LAST_PICOM="$PICOM_NOW"
        feh --bg-fill "$PNG"
        WALL=$(grep -oP "'\K[^']+\.(jpg|jpeg|png|webp)" ~/.fehbg | grep -Ev "hy.png" | head -n1)
        LAST_WALL="$WALL"
        sleep 0.8
        continue
    fi

    # --- 4. Deteksi perubahan wallpaper manual ---
    if [ "$WALL" != "$LAST_WALL" ]; then
        if [ "$CURRENT" = "static" ]; then
            taskset -c 0 nice -n 19 ionice -c3 stdbuf -oL -eL chrt --idle 0 "$SCRIPT" manual
        else
            taskset -c 0 nice -n 19 ionice -c3 stdbuf -oL -eL chrt --idle 0 "$SCRIPT" live
        fi
        LAST_WALL="$WALL"
        sleep 0.842
        continue
    fi

    sleep 0.842
done
