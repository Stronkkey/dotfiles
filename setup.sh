#!/bin/sh
[ -f /bin/lsb_release ] || echo "Please Download lsb-release!" && exit 1

distro="$(lsb_release -si)"

[ "$distro" != "Artix" ] && [ "$distro" != "Arch" ] && echo "Not arch or artix" && exit 1

GTK_THEME_SOURCE="https://github.com/i-mint/LightningBug.git" # Theme Git repo
GTK_THEME_NAME="LightningBug" # This should be equal to the repos name
GTK_COPY_NAME="Lightningbug-Dark" # What to copy from the themes dir
AUR_SOURCE="https://aur.archlinux.org"

[ "$(id -u)" = "0" ] && echo "Do not run this as root as it can cause damage!" && exit 1
echo -e "Note: you need to have a working Internet connection."
echo "Are you sure you want to install my dotfiles?. THIS WILL REPLACE YOU ~/.config, ~/.zprofile AND /etc/pacman.conf!"
read ques
[ "$ques" != "y" ] && echo "Cancelling setup. user said no"  && exit 1
 #Add Arch Repos
 #Artix add arch repos ( artix specific)
artix_spec() {
	[ -f "/etc/pacman.d/mirrorlist-arch" ] || echo "Adding Arch repos." && sudo pacman -S --needed --noconfirm artix-archlinux-support && sudo pacman-key --populate archlinux && echo "Added Arch repos"
	 sudo cp ./pacman-artix.conf /etc/pacman.conf
}
# For Arch
arch_spec() {
	sudo cp ./pacman-arch /etc/pacman.conf
	echo "Added multilib to repo pool"
}
#Add chaotic-aur

add_chaotic() { 
	 echo "Adding the chaotic AUR"
	 sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
	 sudo pacman-key --lsign-key 3056513887B78AEB
	 sudo pacman -U --needed --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
}

[ -f "/etc/pacman.d/chaotic-mirrorlist" ] || add_chaotic || echo "Error adding chaotic-aur" && exit 1

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


echo "~/.config IS GOING TO BE DELETED NOW. A BACKUP IS IN ~/.config.bak"
echo "Moving Wallpaper to /opt"
sudo mv "./City.jpg" /opt/Paper.jpg

[ -f $HOME/.config ] && cp -r $HOME/.config $HOME/.config.bak && rm -rf $HOME/.config && echo "Backed up ~/.config"
cp -R "./.config" "$HOME/.config"

## Installing Theme
git clone $GTK_THEME_SOURCE
sudo mv $GTK_THEME_NAME/$GTK_COPY_THEME /usr/share/themes
echo "Installed $GTK_THEME_NAME"
#Change some core stuff
echo "Copying .zprofile to ~"
sudo cp ./zprofile $HOME/.zprofile
echo "Changing shell"
sudo chsh -s /bin/zsh $USER
sudo chsh -s /bin/zsh root
echo "Done!"
echo "Unless there were errors. the setup was successful."
