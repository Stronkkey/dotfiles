#!/bin/zsh
# This place is for Startup.
# This is used for auto completion.
zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots)

#####################
# These are various keyboard related things.

typeset -g -A key
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

#####################

# Autoloading Things mostly for eyecandy. and for it to work
autoload -Uz promptinit
autoload -Uz compinit
compinit -D
_comp_options+=(globdots) # Include hidden files.
promptinit
prompt adam2
setopt interactive_comments # make comments dark
##
# This is for for auto syntax and autosuggestions.
# NOTE: You need zsh-syntax-highlighting and zsh-autosuggestions for it to work
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
##
# if a command is not found it is going to look in the database for a program
source /usr/share/doc/pkgfile/command-not-found.zsh
##

# Aliases
alias vim=nvim
alias e="$EDITOR"

alias mv="mv -v"
alias rm="rm -v"
alias cp="cp -v --sparse=always" # --sparse=auto to specify that a file is sparse when it is sparse
alias bc="bc -ql"
alias mkdir="mkdir -pv"
alias ffmpeg="ffmpeg -hide_banner"

alias ls="ls -hN --color=auto --group-directories-first"
alias grep="grep --color=auto"
alias diff="diff --color=auto"

alias ka="killall"
alias g="git"
alias v="$EDITOR"
alias p="pacman --color=auto"

alias mpv="mpv --hwdec=auto" # Be sure to enable hardware decoding
for command in mount umount sv shutdown poweroff reboot ; do
	alias $command="doas $command"
done

alias sxiv="imv"
alias hide="setsid -f $1 >/dev/null 2>&1" # Hide output with hide
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"' # Make wget not spawn a .wget-hsts file
