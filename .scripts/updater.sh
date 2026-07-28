kitty -e bash -c '
sudo pacman -Syu --noconfirm
flatpak update -y
sudo pacman -Rns $(pacman -Qdtq) --noconfirm 2>/dev/null || true
echo
read -n 1 -s -r -p "Press enter to exit"
'
