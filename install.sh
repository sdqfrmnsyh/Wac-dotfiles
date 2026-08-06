#!/usr/bin/env bash

set -e

echo "====================================="
echo "      Wac Dotfiles Installer"
echo "====================================="

# --------------------------------------------------
# Install yay
# --------------------------------------------------

if ! command -v yay &>/dev/null; then
    echo "[1/6] Installing yay..."

    sudo pacman -S --needed git base-devel

    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -

    rm -rf /tmp/yay
fi

# --------------------------------------------------
# Install Packages
# --------------------------------------------------

echo "[2/6] Installing dependencies..."

yay -Syu --needed --noconfirm \
polybar \
tint2 \
plank \
picom-ftlabs-git \
rofi \
rofi-emoji \
rofi-power-menu \
dunst \
kitty \
pcmanfm \
fastfetch \
playerctl \
brightnessctl \
pamixer \
networkmanager \
pavucontrol \
scrot \
polkit-gnome \
xorg-xset \
xclip \
ffmpeg \ 
imagemagick \
mission-center \
feh \
mv \
git \
brave-origin-bin \
nano \
wget \
curl \
cp \
unzip \
ananicy-cpp \
cachyos-ananicy-rules \
cava \
htop \
ttf-jetbrains-mono-nerd \
ttf-material-design-icons-desktop \
adobe-source-han-code-jp-fonts \
libnotify \
geany \
alsa-utils \
htop \
ttf-nerd-fonts-symbols-mono

# --------------------------------------------------
# Copy Dotfiles
# --------------------------------------------------

echo "[3/6] Installing dotfiles..."

cp -rf .config "$HOME/"
cp -rf .local "$HOME/"
cp -rf .scripts "$HOME/"
cp -rf Wallpapers "$HOME/"

cp -f .face "$HOME/"

# --------------------------------------------------
# Additional Config
# --------------------------------------------------

echo "[4/6] Installing additional configuration..."

sudo cp -f Additional/tlp.conf /etc/tlp.conf 2>/dev/null || true
sudo mkdir -p /etc/tuned/Modz 2>/dev/null || true
sudo cp -f Additional/tuned.conf /etc/tuned/Modz/tuned.conf 2>/dev/null || true
sudo cp -f Additional/mylifemy.rules /etc/ananicy.d/mylifemy.rules 2>/dev/null || true
sudo cp -f Additional/scx_loader.toml /etc/scx_loader.toml 2>/dev/null || true
sudo cp -f Additional/rofi-power-menu /usr/bin/rofi-power-menu 2>/dev/null || true

# --------------------------------------------------
# Permissions
# --------------------------------------------------

echo "[5/6] Setting permissions..."

chmod -R +x "$HOME/.scripts"
chmod -R +x "$HOME/.local/bin"

# --------------------------------------------------
# Reload Openbox
# --------------------------------------------------

echo "[6/6] Reloading Openbox..."

openbox --reconfigure 2>/dev/null || true

echo
echo "====================================="
echo " Installation Complete!"
echo "====================================="
echo
echo "Please log out and log back in."