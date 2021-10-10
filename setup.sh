#!/bin/sh
# My shitty setup script

echo "DO NOT USE ON REAL MACHINE!"
exit 0
GTK_THEME_SOURCE="https://github.com/i-mint/LightningBug"
AUR_SOURCE="https://aur.archlinux.org"

[ "$(command pacman -V)" ] || echo "Not artix" && exit 0
[ -f "/sbin/runit-init" ] || echo "No runit" && exit 0
[ "$(id -u)" = "0" ] && echo "Do not run this as root" && exit 0
echo "Note: you need to have ProList.txt and .config in the working directory and a Internet connection."
# Stuff from the AUR to install.
# paru-bin vimix-cursors libreddit-git librewolf-bin
echo "Are you sure you want to install my dotfiles?. THIS WILL DELETE YOUR ~/.config FOLDER! "
read ques
[ "$ques" != "y" ] && echo "Cancelling setup. user said no"  && exit 0
sudo pacman -S --needed --noconfirm - < ProLists.txt # Install based software

### Add Arch Repos



sudo pacman -S --needed artix-archlinux-support

sudo pacman-key --populate archlinux

grep -q "ILoveCandy" /etc/pacman.conf || sudo sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

sudo sed -i "s/^#ParallelDownloads = 8$/ParallelDownloads = 5/;s/^#Color$/Color/" /etc/pacman.conf

sudo echo "[lib32]\nInclude = /etc/pacman.d/mirrorlist\n[community]\nInclude = /etc/pacman.d/mirrorlist-arch\n[extra]\nInclude = /etc/pacman.d/mirrorlist-arch\n[multilib]\nInclude = /etc/pacman.d/mirrorlist-arch"

## End

# Installing stuff from the AUR
git clone $AUR_SOURCE/paru-bin.git
git clone $AUR_SOURCE/vimix-cursors
git clone $AUR_SOURCE/libreddit-git
git clone $AUR_SOURCE/librewolf-bin
git clone $AUR_SOURCE/pokemon-colorscripts-git
cd paru-bin && makepkg -si --noconfirm && cd ../ && rm -rf paru-bin
cd vimix-cursors && makepkg -si --noconfirm && cd ../ && rm -rf vimix-cursors
cd libreddit-git && makepkg -si --noconfirm && cd ../ && rm -rf libreddit-git
cd librewolf-bin && makepkg -si --noconfirm && cd ../ && rm -rf librewolf-bin
cd pokemon-colorscripts-git && makepkg -si --noconfirm && cd ../ && rm -rf pokemon-colorscripts-git
# End from install stuff from the AUR
##
mkdir -p $HOME/.local/bin && cd $HOME/.local/bin && ln -f /usr/local/opt/pokemon-colorscripts/pokemon-colorscripts.sh pokemon-colorscripts
chmod +x pokemon-colorscripts
##

rm -rf $HOME/.config
cp -R ./.config $HOME/.config

## Change some core stuff
sudo echo "emulate sh -c \'source $HOME/.config/shell/profile\'" >> /etc/zsh/zprofile
##
