#!/bin/sh

[ ! -f "/bin/pacman" ] && echo "Pacman is not installed" && exit 1
[ ! -f "/bin/sudo" ] && echo "Sudo is not installed" && exit 1

sudo pacman --noconfirm --ask 4 -Syu
[ ! -f "/bin/lsb_release" ] && sudo pacman --noconfirm --ask 4 -S lsb-release
distro="$(lsb_release -si)"

GTK_THEME_SOURCE="https://github.com/i-mint/LightningBug.git" # Theme Git repo
GTK_THEME_NAME="LightningBug" # This should be equal to the repos name
GTK_COPY_NAME="Lightningbug-Dark" # What to copy from the themes dir
AUR_SOURCE="https://aur.archlinux.org"

[ "$(id -u)" = "0" ] && echo "setup.sh cannot not be ran as root" && exit 0
echo "Note: you need to have a working Internet connection."
echo "Are you sure you want to install my dotfiles? This will replace ~/.config, ~/.zprofile and /etc/pacman.conf."
read ques
[ "$ques" != "y" ] && echo "Cancelled setup."  && exit 1
 #Add Arch Repos
 #Artix add arch repos ( artix specific )
artix_spec() {
	[ ! -f "/etc/pacman.d/mirrorlist-arch" ] && echo "Adding Arch repos." && sudo pacman -S --needed --noconfirm artix-archlinux-support && sudo pacman-key --populate archlinux && echo "Added Arch repos"
	 sudo cp ./pacman-artix.conf /etc/pacman.conf
}
# For Arch
arch_spec() {
	sudo cp ./pacman-arch /etc/pacman.conf
	echo "Added multilib to repo pool"
}
#Add chaotic-aur

add_chaotic() { 
	 echo "Adding chaotic AUR"
	 sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
	 sudo pacman-key --lsign-key 3056513887B78AEB
	 sudo pacman -U --needed --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
}

[ ! -f "/etc/pacman.d/chaotic-mirrorlist" ] && add_chaotic

# Distro Stuff
[ "$distro" = "Artix" ] && artix_spec
[ "$distro" = "Arch" ] && arch_spec
echo "Updating System."
sudo pacman -Syu --noconfirm --ask 4
# End
echo "Installing Programs"
sudo pacman -S --needed --noconfirm --ask 4 - < Pkgs.txt
#Installing Pokemon colorscripts from the AUR

pokemon() {
	[ -f ./pokemon-colorscripts-git ] && rm -rfv pokemon-colorscripts-git
	git clone $AUR_SOURCE/pokemon-colorscripts-git.git && cd pokemon-colorscripts-git && makepkg -si --noconfirm --needed && cd .. && rm -rf pokemon-colorscripts-git
}
[ ! -f "/bin/pokemon-colorscripts" ] && pokemon

echo "Moving Wallpaper to /opt"
sudo mv "./City.jpg" /opt/Paper.jpg

[ -f $HOME/.config ] && cp -r $HOME/.config $HOME/.config.bak && rm -rf $HOME/.config && echo "Backed up ~/.config"
cp -R "./.config" "$HOME/.config"

install_theme() {
	git clone $GTK_THEME_SOURCE
	sudo mv $GTK_THEME_NAME/$GTK_COPY_THEME /usr/share/themes
}
## Install Theme
install_theme && echo "Installed $GTK_THEME_NAME" || echo "error installing theme"
#Change some core stuff
echo "Copying .zprofile to ~/"
cp ./zprofile $HOME/.zprofile
echo "Changing shell"
sudo chsh -s /bin/zsh $USER
sudo chsh -s /bin/zsh root
echo "Done"
