#!/bin/sh

send_info() {
	echo "INFO: $1"
}

send_ok() {
	echo "OK: $1"
}

send_warn() {
	echo "WARN: $1"
}

send_error() {
	# We are not using \n here to make this script shell agnostic.
	echo "ERROR: $1" >&2
	echo "Aborting." >&2
	exit 1
}


[ ! -f "/bin/pacman" ] && send_error "Couldn't find pacman in /bin/pacman.
Note that this script only has support for Arch-like and Artix systems at this moment."
[ ! -f "/bin/sudo" ] && send_error "Couldn't find sudo in /bin/sudo."
[ "$(id -u)" = "0" ] && send_error "This script cannot be ran as root. Privileges will be escalated when running as normal user with sudo."
[ ! -f "/bin/lsb_release" ] && sudo pacman --noconfirm --ask 4 -S lsb-release > /dev/null 2>&1

distro="$(lsb_release -si)"
debug_mode_enabled="no"

GTK_THEME_SOURCE="https://github.com/i-mint/LightningBug.git" # Theme Git repo
GTK_THEME_NAME="LightningBug" # This should be equal to the repos name
GTK_COPY_NAME="Lightningbug-Dark" # What to copy from the themes dir
AUR_SOURCE="https://aur.archlinux.org"

if [ "$1" = "debug" ]; then
	debug_mode_enabled="yes"
	send_info "Debug mode enabled."
fi

echo "Note: you need to have a working Internet connection."
echo "Are you sure you want to install my dotfiles? This will replace ~/.config, ~/.zprofile and /etc/pacman.conf."
read ques
[ "$ques" != "y" ] && send_error "Installation has been cancelled."



artix_install_archlinux_support_package() {
	send_info "Installing artix-archlinux-support package."
	sudo pacman -S --needed --noconfirm artix-archlinux-support > /dev/null 2>&1 \
		&& send_ok "artix-archlinux-support packages installed." \
		|| send_error "Failed to install artix-archlinux-support package."
}

artix_populate_archlinux_keys() {
	send_info "Populating archlinux keys."
	sudo pacman-key --populate archlinux > /dev/null 2>&1 \
		&& send_ok "Archlinux keys populated." \
		|| send_error "Failed populating archlinux keys."
}

artix_add_arch_support() {
	send_info "Enabling arch package support for artix."
	artix_install_archlinux_support_package
	artix_populate_archlinux_keys
	send_ok "Arch support enabled."
}

artix_install_pacman_artix_conf() {
	send_info "Installing pacman-artix.conf."
	sudo cp ./pacman-artix.conf /etc/pacman.conf \
		&& send_ok "pacman-artix.conf installed." \
		|| send_error "Failed to install pacman-artix.conf."
}

artix_add_arch_repos() {
	[ -f "/etc/pacman.d/mirrorlist-arch" ] && arch_support=yes || arch_support=no
	[ $arch_support = "no" ] && artix_add_arch_support

	artix_install_pacman_artix_conf
}

arch_add_multilib_repo() {
	send_info "Adding multilib repository."

	sudo cp ./pacman-arch /etc/pacman.conf \
		&& send_ok "multilib Repository added." \
		|| send_error "Failed to add multilib repository."
}

refesh_local_pacman_database() {
	send_info "Refreshing local pacman databases."

	sudo pacman -Sy --noconfirm --ask 4 > /dev/null 2>&1 \
		&& send_ok "Local pacman databases refreshed." \
		|| send_error "Failed to refresh local pacman databases."
}

receive_chaotic_key() {
	send_info "Downloading Chaotic AUR keyid."

	sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com > /dev/null 2>&1 \
		&& send_ok "Chaotic AUR keyid installed." \
		|| send_error "Failed to install Chaotic AUR keyid."
}

sign_chaotic_key() {
	send_info "Signing Chaotic AUR keyid."

	sudo pacman-key --lsign-key 3056513887B78AEB > /dev/null 2>&1 \
		&& send_ok "Chaotic AUR keyid signed." \
		|| send_error "Failed to sign Chaoric AUR keyid."
}

install_chaotic_mirrorlist() {
	send_info "Installing Chaotic AUR mirrorlist."

	sudo pacman -U --needed --noconfirm \
		'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
		'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' > /dev/null 2>&1 \
			&& send_info "Chaotic AUR mirrorlist installed." \
			|| send_error "Failed to install Chaotic AUR mirrorlist."
}

add_chaotic_repo() {
	send_info "Adding Chaotic AUR repository."

	receive_chaotic_key
	sign_chaotic_key
	install_chaotic_mirrorlist

	send_ok "Chaotic AUR repository added."
}

backup_existing_configs() {
	send_warn "Found existing ~/.config. Renaming to ~/.config.bak."

	mv ~/.config ~/.config.bak \
		&& send_ok "~/.config renamed to ~/.config.bak." \
		|| send_error "Failed creating backup of ~/.config."
}

backup_existing_zprofile() {
	send_warn "Found existing ~/.zprofile. Renaming to ~/.zprofile"

	mv ~/.zprofile ~/.zprofile.bak \
		&& send_ok "~/.zprofile renamed to ~/.zprofile.bak." \
		|| send_error "Failed creating backup of ~/.zprofile."
}

install_config_dir() {
	send_info "Installing config files."

	cp -R ./config ~/.config \
		&& send_ok "Config files installed." \
		|| send_error "Failed to install config files."
}

install_zprofile() {
	send_info "Installing .zprofile/"

	cp ./zprofile ~/.zprofile \
		&& send_ok "zprofile installed." \
		|| send_error "Failed to install zprofile."
}

create_wallpaper_directory() {
	send_info "Creating ~/Pictures/Wallpapers."

	mkdir -p ~/Pictures/Wallpapers \
		&& send_info "~/Pictures/Wallpapers created." \
		|| send_error "Failed to create ~/Pictures/Wallpapers."
}

copy_wallpapers() {
	send_info "Copying Wallpapers."

	cp ./Wallpapers/* ~/Pictures/Wallpapers/ \
		&& send_info "Wallpapers copied." \
		|| send_error "Failed to copy Wallpapers."
}

clone_git_theme_repo() {
	send_info "Cloning $GTK_THEME_SOURCE Git repository."

	git clone $GTK_THEME_SOURCE > /dev/null 2>&1 \
		&& send_info "Theme $GTK_THEME_SOURCE cloned." \
		|| send_error "Failed to clone $GTK_THEME_SOURCE theme."
}

install_theme_dir_systemwide() {
	send_info "Moving themes directory."

	sudo mv -f $GTK_THEME_NAME/$GTK_COPY_NAME /usr/share/themes \
		&& send_ok "Themes directory moved" \
		|| send_error "Failed to move themes directory."
}


add_repositories() {
	send_info "Adding repositories."

	[ -f "/etc/pacman.d/chaotic-mirrorlist" ] && chaotic_repo_exists=yes || chaotic_repo_exists=no

	[ $chaotic_repo_exists = "no" ] && add_chaotic_repo

	# Distro Stuff
	[ $distro = "Artix" ] && artix_add_arch_repos
	[ $distro = "Arch" ] && arch_add_multilib_repo

	refesh_local_pacman_database

	send_ok "Repositories added."
}

install_programs() {
	send_info "Installing Programs."

	sudo pacman -Syu --needed --noconfirm --ask 4 - < Pkgs.txt > /dev/null 2>&1 \
		&& send_ok "Programs installed." \
		|| send_error "Failed to install programs."

	send_info "Copying scripts to /usr/local/bin."
	sudo cp -R ./bin/* /usr/local/bin \
		&& send_ok "Scripts copied." \
		|| send_error "Failed to copy scripts."
}

install_config() {
	[ -d ~/.config ] && configs_already_exists=yes || configs_already_exists=no
	[ $configs_already_exists = "yes" ] && backup_existing_configs

	[ -f ~/.zprofile ] && zprofile_already_exists=yes || zprofile_already_exists=no
	[ $zprofile_already_exists = "yes" ] && backup_existing_zprofile

	install_config_dir
	install_zprofile
}

install_wallpapers() {
	send_info "Installing Wallpaper(s)."

	create_wallpaper_directory
	copy_wallpapers

	send_ok "Installed Wallpapers."
}

install_theme() {
	[ -d "/usr/share/themes/$GTK_COPY_NAME" ] && send_warn "Theme $GTK_THEME_NAME already installed. Skipping" && return

	send_info "Installing $GTK_THEME_NAME theme."

	clone_git_theme_repo
	install_theme_dir_systemwide

	send_ok "Installed $GTK_THEME_NAME theme."
}

change_shell() {
	send_info "Changing shell for $USER to zsh."

	sudo chsh -s /bin/zsh $USER > /dev/null 2>&1 \
		&& send_ok "Shell for $USER changed to zsh." \
		|| send_error "Failed to change shell for $USER."
}

[ $debug_mode_enabled = "no" ] && add_repositories || send_info "Debug mode enabled, skipping adding repositories."

install_programs
install_config
install_wallpapers
install_theme
change_shell


echo "Installation finished successfully."