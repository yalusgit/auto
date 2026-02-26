#!/bin/bash
set -e

# ============================================================
#  dotfiles install script
#  Tested on Debian 13 (Trixie) minimal install
# ============================================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USERNAME="${SUDO_USER:-$USER}"
HOME_DIR="/home/$USERNAME"

echo ">>> Installing dotfiles for user: $USERNAME"
echo ">>> Dotfiles directory: $DOTFILES_DIR"

# 1. System update
echo ">>> Updating system..."
sudo apt update && sudo apt upgrade -y

# 2. Install packages
echo ">>> Installing packages..."
sudo apt install -y \
    xorg xinit xserver-xorg \
    i3 i3lock polybar \
    picom \
    kitty \
    rofi \
    nitrogen \
    fonts-font-awesome fonts-noto \
    pulseaudio pulseaudio-utils pavucontrol \
    network-manager network-manager-gnome \
    dex xss-lock \
    polkitd mate-polkit \
    stow \
    git curl wget unzip htop \
    ffmpeg inxi python3-pip

# install scdl via pip
echo ">>> Installing scdl..."
pip3 install scdl --break-system-packages

# 3. Enable services
echo ">>> Enabling NetworkManager..."
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

# 4. Stow dotfiles
echo ">>> Symlinking dotfiles with stow..."
cd "$DOTFILES_DIR"

for pkg in i3 polybar kitty rofi picom bash; do
    echo "  stowing $pkg..."
    stow --target="$HOME_DIR" --restow "$pkg"
done

# 5. .xinitrc
echo ">>> Setting up .xinitrc..."
if [ -f "$HOME_DIR/.xinitrc" ]; then
    echo "  Backing up existing .xinitrc to .xinitrc.bak"
    mv "$HOME_DIR/.xinitrc" "$HOME_DIR/.xinitrc.bak"
fi
stow --target="$HOME_DIR" --restow x

# 6. Wallpaper directory
echo ">>> Setting up wallpaper directory..."
mkdir -p "$HOME_DIR/Pictures"
if [ ! -L "$HOME_DIR/Pictures/wallpaper" ]; then
    ln -s "$DOTFILES_DIR/wallpapers" "$HOME_DIR/Pictures/wallpaper"
fi

# 7. Fix permissions
chmod +x "$HOME_DIR/.config/polybar/launch.sh"

echo ""
echo "♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡"
echo " All done!"
echo "  1. Add wallpaper(s) to ~/Pictures/wallpaper/"
echo "  2. Run: startx"
echo "  3. Run: .config/polybar/launch.sh"
echo "♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡"
