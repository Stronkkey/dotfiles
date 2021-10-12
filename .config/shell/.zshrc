#!/bin/zsh
# This place is for Startup.
# This is used for auto completion.
zstyle ':completion:*' menu select gain-privileges 1
zmodload zsh/complist
_comp_options+=(globdots)
setopt COMPLETE_ALIASES
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
#autoload -Uz promptinit
autoload -Uz compinit
compinit -D $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b " # Colors. i guess
setopt interactive_comments # make comments work
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

alias mv="mv -v"
alias rm="rm -v"
alias mkdir="mkdir -pv"

alias ls="exa"

alias mpv="mpv --hwdec=auto" # Be sure to enable hardware decoding
for command in mount umount sv shutdown poweroff reboot ; do
	alias $command="doas $command"
done

alias hide="setsid -f $1 >/dev/null 2>&1" # Hide output with hide
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"' # Make wget not spawn a .wget-hsts file

pokemon-colorscripts -r
# i use artix btw
