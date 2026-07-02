#!/bin/bash

killall dunst
killall tint2

TINT="$HOME/.config/tint2/tint2rc"
DUNST="$HOME/.config/dunst/dunstrc"

TMPIMG="/tmp/wallframe.png"

VID=$(ps aux | grep '[x]winwrap' | grep -oE '[^ ]+\.(mp4|mkv|webm|gif)' | head -n1)

if [ -n "$VID" ]; then

    # live wallpaper aktif
    ffmpeg -y -loglevel quiet -ss 00:00:00 -i "$VID" -frames:v 1 "$TMPIMG"

    SRC="$TMPIMG"
    MODE="live"

else

    # live wallpaper tidak ada
    WALL=$(find ~/Wallpapers -type f | shuf -n1)

    SRC="$WALL"
    MODE="static"

fi

[ -z "$SRC" ] && exit

# ambil warna dari wallpaper
read r1 g1 b1 <<< $(magick "$SRC" -format "%[fx:int(255*p{0,0}.r)] %[fx:int(255*p{0,0}.g)] %[fx:int(255*p{0,0}.b)]" info:)
read r2 g2 b2 <<< $(magick "$SRC" -format "%[fx:int(255*p{w-1,0}.r)] %[fx:int(255*p{w-1,0}.g)] %[fx:int(255*p{w-1,0}.b)]" info:)
read r3 g3 b3 <<< $(magick "$SRC" -format "%[fx:int(255*p{0,h-1}.r)] %[fx:int(255*p{0,h-1}.g)] %[fx:int(255*p{0,h-1}.b)]" info:)
read r4 g4 b4 <<< $(magick "$SRC" -format "%[fx:int(255*p{w-1,h-1}.r)] %[fx:int(255*p{w-1,h-1}.g)] %[fx:int(255*p{w-1,h-1}.b)]" info:)

R=$(( (r1+r2+r3+r4)/4 ))
G=$(( (g1+g2+g3+g4)/4 ))
B=$(( (b1+b2+b3+b4)/4 ))

COLOR=$(printf "#%02x%02x%02x" $R $G $B)
COLOR_TINT=$(echo "$COLOR" | tr '[:lower:]' '[:upper:]')

# update tint2
awk -v color="$COLOR_TINT" '
/# Background 1/ {found=1}
found && /background_color/ {
    sub(/#.*/ , color" ")
    found=0
}
{print}
' "$TINT" > "$TINT.tmp" && mv "$TINT.tmp" "$TINT"

# update dunst
awk -v color="$COLOR" '
/background =/ {
    sub(/".*"/, "\""color"\"")
}
{print}
' "$DUNST" > "$DUNST.tmp" && mv "$DUNST.tmp" "$DUNST"

# apply wallpaper di akhir
feh --bg-fill "$SRC"

# reload UI
taskset -c 0 nice -n 19 ionice -c3 chrt --idle 0 tint2&

