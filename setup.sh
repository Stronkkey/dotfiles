#!/bin/sh
#My shitty setup script
echo                "NOTE"
echo "##### This is experimental. #####"
echo "     #######################"
sleep 2

sudo pacman -S --noconfirm --needed lsb-release
distro="$(lsb_release -si)"

GTK_THEME_SOURCE="https://github.com/i-mint/LightningBug"
AUR_SOURCE="https://aur.archlinux.org"

[ "$(id -u)" = "0" ] && echo "Do not run this as root as it can cause damage!" && exit 0
echo "\n\nNote: you need to have Pkgs.txt and .config in the working directory and a Internet connection.\n\n"
# Stuff from the AUR to install.
# paru-bin vimix-cursors libreddit-git librewolf-bin
echo "Are you sure you want to install my dotfiles?. THIS WILL REPLACE YOU ~/.config, /etc/zsh/zprofile AND /etc/pacman.conf!"
read ques
[ "$ques" != "y" ] && echo "Cancelling setup. user said no"  && exit 0
 #Add Arch Repos
 #Artix add arch repos ( artix specific)
artix_spec() {
	sudo pacman -S --needed artix-archlinux-support
	sudo pacman-key --populate archlinux
	sudo rm /etc/pacman.conf && sudo cp ./pacman-artix.conf /etc/pacman.conf
}
# For Arch
arch_spec() {
	sudo rm /etc/pacman.conf && sudo cp ./pacman-arch /etc/pacman.conf
 #Add chaotic-aur

pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

# Distro Stuff
[ "$distro" = "Artix" ] && artix_spec
[ "$distro" = "Arch" ] && arch_spec

sudo pacman -Syu --noconfirm
# End
sudo pacman -S --needed --noconfirm - < Pkgs.txt
#Installing stuff from the AUR
sudo pacman -S --needed --noconfirm paru vimix-cursors libreddit-git librewolf
cd pokemon-colorscripts-git && makepkg -si --noconfirm && cd ../ && rm -rf pokemon-colorscripts-git
#End from install stuff from the AUR

mkdir -p $HOME/.local/bin && cd $HOME/.local/bin && ln -f /usr/local/opt/pokemon-colorscripts/pokemon-colorscripts.sh pokemon-colorscripts
chmod +x pokemon-colorscripts

[ -f $HOME/.config ] && cp -r $HOME/.config $HOME/.config.bak && rm -rf $HOME/.config
cp -R ./.config $HOME/.config

# Change some core stuff
sudo cp $PWD/zprofile /etc/zsh/zprofile
sudo chsh -s /bin/zsh $USER
sudo chsh -s /bin/zsh root


## Add services

enable_runit_services() {
       sudo pacman -S --needed --noconfirm - < PkgsRUNIT.txt
       for rserv in lightdm NetworkManager dnsmasq
       	do sudo ln -s /etc/runit/sv/$rserv /run/runit/runsvdir/default
       done
}

enable_openrc_services() {
       sudo pacman -S --needed --noconfirm - < PkgsOPENRC.txt
       for oserv in lightdm NetworkManager dnsmasq
               do sudo rc-update add $oserv
       done
}
enable_s6_services() {
       sudo pacman -S --needed --noconfirm - < PkgsS6.txt
       for sserv in lightdm NetworkManager dnsmasq
               do sudo s6-rc-bundle-update add default $sserv
       done
}
enable_suite66_services() {
       sudo pacman -S --needed --noconfirm - < Pkgs66.txt
       for seerv in lightdm NetworkManager dnsmasq
               do sudo 66-enable -t default $seerv
       done
}
soystemd() {
	for i in lightdm NetworkManager dnsmasq
		do systemctl enable $i.service
	done
}
detect_init() {
	[ -f "/usr/bin/runit-init" ] && enable_runit_services && exit 1
	[ -f "/usr/bin/openrc-init" ] && enable_openrc_services && exit 1
	[ -f "/usr/bin/s6-init" ] && enable_s6_services && exit 1
	[ -f "/usr/bin/suite66-init" ] && enable_suite66_services && exit 1
	[ -f "/usr/bin/systemctl" ] && soystemd  && exit 1
}
detect_init
