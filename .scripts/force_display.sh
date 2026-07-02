#!/bin/bash

# === CONFIG ===
WIDTH=960
HEIGHT=540
REFRESH=60

# === DETECT OUTPUT HDMI ===
OUTPUT=$(xrandr | grep " connected" | grep HDMI | awk '{print $1}' | head -n1)

if [ -z "$OUTPUT" ]; then
    echo "HDMI tidak ditemukan. Hidup memang tidak selalu sesuai harapan."
    exit 1
fi

echo "Output terdeteksi: $OUTPUT"

# === GENERATE MODELINE DARI CVT ===
MODEL=$(cvt -r $WIDTH $HEIGHT $REFRESH | grep Modeline)

# Ambil nama mode (di dalam tanda kutip)
MODE_NAME=$(echo $MODEL | awk -F\" '{print $2}')

# Ambil isi modeline (tanpa kata 'Modeline' dan tanpa nama)
MODELINE=$(echo $MODEL | cut -d' ' -f3- | sed "s/\"$MODE_NAME\"//")

echo "Mode: $MODE_NAME"
echo "Modeline: $MODELINE"

# === TAMBAH MODE (kalau belum ada) ===
if ! xrandr | grep -q "$MODE_NAME"; then
    echo "Menambahkan mode baru..."
    xrandr --newmode "$MODE_NAME" $MODELINE
else
    echo "Mode sudah ada"
fi

# === TAMBAH KE OUTPUT ===
if ! xrandr | grep -A10 "^$OUTPUT" | grep -q "$MODE_NAME"; then
    echo "Mengaitkan ke output..."
    xrandr --addmode "$OUTPUT" "$MODE_NAME"
fi

# === APPLY ===
echo "Mengaktifkan resolusi..."
xrandr --output "$OUTPUT" --mode "$MODE_NAME" --panning "$MODE_NAME" --set "scaling mode" "Full" --set "underscan" on

echo "Selesai. Kalau gagal, ya… kita sudah berusaha."
