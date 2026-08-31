## Used to be in ~/.config/shell
#
# Default programs:
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="firefox"

# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_DIR="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_DIRS="/etc/xdg:$XDG_CONFIG_HOME"

export ZDOTDIR="$HOME/.config/shell"
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
export CALCHISTFILE="$XDG_CACHE_HOME"/calc_history
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

# Other program settings:
export DICS="/usr/share/stardict/dic/"
export SUDO_ASKPASS="bemenu"
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
export LESS=-R
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"
export QT_QPA_PLATFORMTHEME="qt6ct"
export QT_WAYLAND_FORCE_DPI=physical
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_ENABLE_HIGHDPI_SCALING=1
export SDL_VIDEODRIVER=wayland # May not work for certain Applications
export ECORE_EVAS_ENGINE=wayland_egl
export ELM_ENGINE=wayland_egl
export MOZ_USE_XINPUT2="1" # Mozilla smooth scrolling/touchpads.
export AWT_TOOLKIT="MToolkit wmname LG3D" # May have to install wmname
export _JAVA_AWT_WM_NONREPARENTING=1 # Fix for Java applications in dwm

export GRIM_DEFAULT_DIR="$HOME/Pictures/Screenshots/"
export XDG_SESSION_TYPE=wayland
export ANV_DEBUG=video-decode,video-encode # Video Hardware acceleration with Vulkan. Disable if you Graphics don't support Vulkan.

AutoStart() {
	killall pipewire pipewire-pulse wireplumber > /dev/null 2>&1

	setsid -f pipewire > /dev/null 2>&1
	setsid -f pipewire-pulse > /dev/null 2>&1
	setsid -f wireplumber > /dev/null 2>&1
}

AutoStart