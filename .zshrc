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

# Autoloading Things for eyecandy. and for it to work
autoload -Uz promptinit
autoload -Uz compinit
compinit
promptinit
prompt adam2
##
# This is for for auto syntax and autosuggestions.
# NOTE: You need zsh-syntax-highlighting and zsh-autosuggestions for it to work
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
##
# if a command is not found it is going to look in the database for a program
source /usr/share/doc/pkgfile/command-not-found.zsh
##
# Variables

EDITOR="nvim"
TERMINAL="alacritty"
BROWSER="firefox"

# Aliases
alias vim=nvim
alias e=$EDITOR
alias mv="mv -v"
alias rm="rm -v"
alias cp="cp -v --sparse=auto" # --sparse=auto to specify that a file is sparse when it is sparse
alias mpv="mpv --hwdec=auto" # Be sure to enable hardware decoding
alias pss="doas pacman --color auto -S"
alias psss="pacman --color auto -Ss"
alias pacman="/usr/bin/pacman --color auto"
fpath+=${ZDOTDIR:-~}/.zsh_functions
