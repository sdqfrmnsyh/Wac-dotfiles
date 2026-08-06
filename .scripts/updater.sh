kitty -e bash -c '
yay -Syyu --noconfirm
flatpak update -y
echo
read -n 1 -s -r -p "Press enter to exit"
'
