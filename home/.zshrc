# Homeshick (dotfile management) {{{
if [ -f "$HOME/.homesick/repos/homeshick/homeshick.sh" ]; then
	source "$HOME/.homesick/repos/homeshick/homeshick.sh"
	fpath=("$HOME/.homesick/repos/homeshick/completions" $fpath)
fi

# alias ls to list because I can never remember this one
eval "$(echo "orig_homeshick() {"; declare -f homeshick | tail -n +2)"
function homeshick () {
	if [ "$1" = "ls" ]; then
		shift 1
		orig_homeshick list "$@"
	else
		orig_homeshick "$@"
	fi
}

# }}}
#
# Shell Environment Variables (EDITOR, LANG, etc.) {{{
export LANG=en_US.UTF-8

# These should be pretty standard, we'll customize later
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/.local/bin"
export MANPATH="/usr/local/share/man:/usr/share/man"

# Remote editor
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='vim'
# Local editor
else
	export EDITOR='vim'
fi

# Send xterm-256color as TERM with SSH
alias ssh='TERM=xterm-256color ssh'
# }}}

# System Theming {{{
# Qt theme
export QT_STYLE_OVERRIDE="gtk"

# man (Add colors)
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[01;31m") \
		LESS_TERMCAP_md=$(printf "\e[01;38;5;74m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[38;5;246m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[04;38;5;146m") \
			man "$@"
}

# bat syntax highlighter
export BAT_THEME="Nord"

# Nord theme for fzf
export FZF_DEFAULT_OPTS='--height=40% --reverse --info=inline
    --color=fg:#e5e9f0,bg:#3b4252,hl:#81a1c1
    --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1
    --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
    --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b'
# }}}

# Programming {{{
# ag (tag) -- Generate shell aliases for matches
if (( $+commands[tag] )); then
	tag() { command tag "$@"; source ${TAG_ALIAS_FILE:-/tmp/tag_aliases} 2>/dev/null }
	alias ag="TAG_SEARCH_PROG=ag tag"
	alias rg="TAG_SEARCH_PROG=rg tag"
fi

# Android platform-tools (adb/fastboot/etc.)
if [ -d "/opt/android-sdk/platform-tools" ]; then
	export PATH="$PATH:/opt/android-sdk/platform-tools"
fi

# Golang
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# Flutter
if [ -d "/opt/flutter" ]; then
	export PATH="$PATH:/opt/flutter/bin"
fi

# Use current path as new GOPATH, and include the bin in PATH
function gohere () {
	export PATH="$(pwd)/bin:$PATH"
	export GOPATH="$(pwd)"
}

# Javascript (node / npm)
export NPM_PACKAGES="$HOME/.npm-packages"
if [ -d "$NPM_PACKAGES" ]; then
	export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
	export PATH="$PATH:$NPM_PACKAGES/bin"
	export MANPATH="$NPM_PACKAGES/share/man:$MANPATH"
fi

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "/usr/share/nvm/nvm.sh" ] && \. "/usr/share/nvm/nvm.sh" # This loads nvm

# PHP (composer)
if [ -d "$HOME/.config/composer" ]; then
	export PATH="$PATH:$HOME/.config/composer/vendor/bin"
fi

# Python (pip)
if [ $(uname -s) = "Darwin" ]; then
	export PATH="$PATH:$HOME/Library/Python/3.9/bin"
fi

# Python (virtualenvwrapper)
if [ "$(which virtualenvwrapper.sh)" ]; then
	# Default to Python 3
	VIRTUALENVWRAPPER_PYTHON="$(which python3)"

	. "$(which virtualenvwrapper.sh)"
fi

# Ruby
# Add RVM to PATH for scripting
if [ -d "$HOME/.rvm" ]; then
	export PATH="$PATH:$HOME/.rvm/bin"
	source "$HOME/.rvm/scripts/rvm"
fi


# Rust
if [ -f "$HOME/.cargo/env" ]; then
	source "$HOME/.cargo/env"
fi
# }}}

# oh-my-zsh configuration & bootstrapping {{{
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/.zsh-custom"


# Install oh-my-zsh if it is not already installed
if [ ! -d "$ZSH" ]; then
	echo "oh-my-zsh is not installed -- installing it!"

	command -v git > /dev/null 2>&1 || {
		echo "Git is not installed -- can't install oh-my-zsh"
		return 1
	}

	env git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $ZSH || {
		echo "Failed cloning oh-my-zsh -- can't install oh-my-zsh"
		return 1
	}
fi

# Install powerlevel10k theme
export PL10K="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$PL10K" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enabled Plugins
plugins=(fzf golang pip tpm virtualenvwrapper)

# Update without asking
DISABLE_UPDATE_PROMPT=true

# oh-my-zsh theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source "$ZSH/oh-my-zsh.sh"
# }}}

# Custom aliases and functions {{{
# System-specific private config
[[ -f "$HOME/.zshrc_local" ]] && source "$HOME/.zshrc_local"

alias shot="maim -s ~/screenshots/maim-$(date +%s).png"

# Git aliases {{{
function gco() {
    if [ $# -eq 0 ]; then
        git checkout $(git branch | fzf --header "git checkout")
    else
        git checkout $@
    fi
}
compdef _git gco=git-checkout

function gbd() {
    if [ $# -eq 0 ]; then
        git branch -D $(git branch | fzf --multi --header "git branch -D")
    else
        git branch -D $@
    fi
}
compdef _git gbd=git-branch

alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gcp="git cherry-pick"
alias gd="git diff"
alias gdc="git diff --cached"
alias glg="git log"
alias gst="git status"
# }}}

# Load Yubikey into ssh-agent
function yk4() {
	# check if yubico-piv-tool is installed
	local program="/usr/lib/opensc-pkcs11.so"
	if [ ! -f "${program}" ]; then
		program="/usr/lib/libykcs11.so"
	fi
	if [ ! -f "${program}" ] ; then
		echo "opensc and/or yubico-piv-tool must be installed to add Yubikey to ssh-agent."
		return 1
	fi

	# remove existing Yubikey from ssh-agent if loaded
	# TODO: I think the libykcs11 version is broken (comment changed)
	[ $(ssh-add -L | grep "PIV AUTH pubkey" | wc -l) -ne 0 ] && ssh-add -e /usr/lib/opensc-pkcs11.so
	[ $(ssh-add -L | grep libykcs11 | wc -l) -ne 0 ] && ssh-add -e /usr/lib/libykcs11.so

	# load Yubikey
	if [ -f "$HOME/.ssh-pass" ]; then
		local pass=$(cat "$HOME/.ssh-pass")
		expect << EOF
			spawn ssh-add -s "${program}"
			expect "Enter passphrase for PKCS#11"
			send "${pass}\r"
			expect eof
EOF
	else;
		ssh-add -s "${program}"
	fi
}

# Print duoconnect relay hosts and corresponding relay storage file
function map_relaystorage() {
	# duoconnect doesn't pad its encoding properly
	local base64_pad='{printf($0);for(i=0;(length($0)+i++)%4>0;)printf("=");printf("\n")}'

	for f in ~/.duoconnect/relaystorage/*; do
		local decoded=$(basename "${f}" .json | awk "${base64_pad}" | base64 -d)
		echo "${decoded} ${f}"
	done | column -t
}

# Fetch the weather for a location
function weather() {
	local default_location="Columbus, OH"
	curl "https://wttr.in/$(echo "${argv[@]:-${default_location}}" | sed 's/ /+/g')"
}
# }}}
# vim: foldmethod=marker:foldlevel=0
