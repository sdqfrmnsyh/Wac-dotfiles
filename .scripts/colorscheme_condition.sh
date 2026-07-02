#!/bin/bash

MODE="$1"
SCRIPT="$HOME/.scripts/colorscheme_condition.sh"
TINT="$HOME/.config/tint2/tint2rc"
DUNST="$HOME/.config/dunst/dunstrc"
TMPIMG="/tmp/wallframe.png"

# ======================
# Tentukan source wallpaper
# ======================

if [ "$MODE" = "live" ]; then

    VID=$(pgrep -af xwinwrap | grep -oE '[^ ]+\.(mp4|mkv|webm|gif)' | head -n1 | grep -Ev "hy.png")

    [ -z "$VID" ] && exit

    ffmpeg -y -loglevel quiet -ss 00:00:01 -i "$VID" -frames:v 1 "$TMPIMG"
    SRC="$TMPIMG"

    # sync biar tint2 transparansi gak bug
    feh --bg-fill "$TMPIMG"

elif [ "$MODE" = "static" ]; then

    WALL=$(find ~/Wallpapers -type f | shuf -n1 | grep -Ev "hy.png")
    [ -z "$WALL" ] && exit

    SRC="$WALL"
    feh --bg-fill "$SRC"

elif [ "$MODE" = "manual" ]; then

    SRC=$(grep -oP "'\K[^']+\.(jpg|jpeg|png|webp)" ~/.fehbg | head -n1 | grep -Ev "hy.png")
    [ -z "$SRC" ] && exit

else
    if pgrep -x xwinwrap >/dev/null 2>&1; then
        VID=$(pgrep -af xwinwrap | grep -oE '[^ ]+\.(mp4|mkv|webm|gif)' | head -n1 | grep -Ev "hy.png")
        [ -z "$VID" ] && exit
        ffmpeg -y -loglevel quiet -ss 00:00:01 -i "$VID" -frames:v 1 "$TMPIMG"
        SRC="$TMPIMG"
        feh --bg-fill "$TMPIMG"
    else
        WALL=$(find ~/Wallpapers -type f | shuf -n1 | grep -Ev "hy.png")
        [ -z "$WALL" ] && exit
        SRC="$WALL"
        feh --bg-fill "$SRC"
    fi
fi

# ======================
# Ambil warna (4 sampling)
# ======================

read r1 g1 b1 <<< $(magick "$SRC" -format "%[fx:int(255*p{0,0}.r)] %[fx:int(255*p{0,0}.g)] %[fx:int(255*p{0,0}.b)]" info:)
read r2 g2 b2 <<< $(magick "$SRC" -format "%[fx:int(255*p{w-1,0}.r)] %[fx:int(255*p{w-1,0}.g)] %[fx:int(255*p{w-1,0}.g)]" info:)
read r3 g3 b3 <<< $(magick "$SRC" -format "%[fx:int(255*p{0,h-1}.r)] %[fx:int(255*p{0,h-1}.g)] %[fx:int(255*p{0,h-1}.b)]" info:)
read r4 g4 b4 <<< $(magick "$SRC" -format "%[fx:int(255*p{w-1,h-1}.r)] %[fx:int(255*p{w-1,h-1}.g)] %[fx:int(255*p{w-1,h-1}.b)]" info:)

R=$(( (r1+r2+r3+r4)/4 ))
G=$(( (g1+g2+g3+g4)/4 ))
B=$(( (b1+b2+b3+b4)/4 ))

COLOR=$(printf "#%02x%02x%02x" $R $G $B)
COLOR_TINT=$(echo "$COLOR" | tr '[:lower:]' '[:upper:]')

# ======================
# Update Tint2 (Background 1 ONLY)
# ======================

awk -v color="$COLOR_TINT" '
/# Background 1/ {found=1}
found && /background_color/ {
    sub(/#.*/ , color" 25")
    found=0
}
{print}
' "$TINT" > "$TINT.tmp" && mv "$TINT.tmp" "$TINT"

# ======================
# Update Dunst
# ======================

awk -v color="$COLOR" '
/background =/ {
    sub(/".*"/, "\""color"\"")
}
{print}
' "$DUNST" > "$DUNST.tmp" && mv "$DUNST.tmp" "$DUNST"

# ======================
# Reload UI
# ======================

killall tint2 2>/dev/null
killall dunst 2>/dev/null
taskset -c 0 nice -n 19 ionice -c3 stdbuf -oL -eL chrt --idle 0 tint2&

rm -f "$TMPIMG"
