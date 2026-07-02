#!/bin/bash
# Script update foto profil otomatis

FOTO="$HOME/.face"  # ganti ini ke file baru kamu
TARGET="$HOME/.face"

# Copy file ke ~/.face
cp "$FOTO" "$TARGET"

# Set permission & owner
chmod 644 "$TARGET"
chown $USER:$USER "$TARGET"

# Restart AccountsService biar apply
sudo systemctl restart accounts-daemon

echo "Foto profil berhasil diperbarui!"
