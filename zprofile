export ZDOTDIR="$HOME/.config/shell"
## Used to be in ~/.config/shell
# Default programs:
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="librewolf"
# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_SESSION_TYPE=wayland-egl # Tells QT to use wayland backend (does not work in qt4)
export XDG_DATA_DIRS="/usr/local/share:/usr/share:$XDG_DATA_HOME"
export XDG_CONFIG_DIRS="/etc/xdg:$XDG_CONFIG_HOME"
export NOTMUCH_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/notmuch-config"
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc"
export AUR_SOURCE="https://aur.archlinux.org/"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export LESSHISTFILE="-"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
export GNUPGHOME="${XDG_DATA_HOME:-$HOME/.local/share}/gnupg"
export RANDFILE="${XDG_DATA_HOME:-$HOME/.local/share}/rnd"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
export WINEPREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/wineprefixes/default"
export KODI_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/kodi"
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/password-store"
export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks" 
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export ANDROID_SDK_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/android"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export ANSIBLE_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/ansible/ansible.cfg"
export UNISON="${XDG_DATA_HOME:-$HOME/.local/share}/unison"
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zhistory"
export WEECHAT_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/weechat"
export MBSYNCRC="${XDG_CONFIG_HOME:-$HOME/.config}/mbsync/config"
export ELECTRUMDIR="${XDG_DATA_HOME:-$HOME/.local/share}/electrum"

# Other program settings:
export DICS="/usr/share/stardict/dic/"
export SUDO_ASKPASS="bemenu"
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
export LESS=-R
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"
export QT_QPA_PLATFORMTHEME="gtk2"	# Have QT use gtk2 theme.
export QT_STYLE_OVERRIDE="gtk2"
#export SDL_VIDEODRIVER=wayland # Buggy
export ECORE_EVAS_ENGINE=wayland_egl
export ELM_ENGINE=wayland_egl
export MOZ_USE_XINPUT2="1"		# Mozilla smooth scrolling/touchpads.
export AWT_TOOLKIT="MToolkit wmname LG3D"	#May have to install wmname
export _JAVA_AWT_WM_NONREPARENTING=1	# Fix for Java applications in dwm
export MOZ_ENABLE_WAYLAND=1 # Enables wayland support in firefox.
export XDG_CURRENT_DESKTOP=Unity

Update() {
	echo "Do you want to update?"
	echo "[N] No\n[Y] Yes\n[A] Yes and automatically"
	read choice
	[ "$choice" = "N" ] && echo "Did not update." || [ "$choice" = "n" ] && echo "Did not update."
	[ "$choice" = "Y" ] && sudo pacman -Syu && echo "Updated sucessfuly" || [ "$choice" = "y" ] && sudo pacman -Syu && echo "Updated sucessfuly"
	[ "$choice" = "A" ] && sudo pacman -Syu --ask 4 --noconfirm > /dev/null 2>&1 && echo "Updated sucessfuly" || [ "$choice" = "a" ] && sudo pacman -Syu --ask 4 --noconfirm > /dev/null 2>&1 && echo "Updated sucessfuly"
}

ExecuteSway() {
exec sway && exit 0
}
Executei3() {
	echo "exec i3" > $XINITRC && startx $XINITRC $XSERVERRC && exit 0
}
Main() {
        echo "Pick a session"
        echo "i3 [1] Sway [2]"
        read Pick
	[ "$Pick" = "1" ] && Executei3
	[ "$Pick" = "2" ] && ExecuteSway
        exec zsh
}
[ "$XDG_RUNTIME_DIR" ] && [ -z "$DISPLAY" ] &&  Main
