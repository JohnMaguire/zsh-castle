# Homeshick (dotfile management) {{{
if [ -f "$HOME/.homesick/repos/homeshick/homeshick.sh" ]; then
	source "$HOME/.homesick/repos/homeshick/homeshick.sh"
	fpath=("$HOME/.homesick/repos/homeshick/completions" $fpath)
fi
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
	export EDITOR='nvim'
fi
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
# }}}

# Applications {{{
# Android platform-tools (adb/fastboot/etc.)
export PATH="$PATH:/opt/android-sdk/platform-tools"
# }}}

# Programming {{{
# Golang
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# Ruby (RubyGems)
export PATH="$PATH:$HOME/.gem/ruby/2.2.0/bin"

# Javascript (node / npm)
export NPM_PACKAGES="$HOME/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
export PATH="$PATH:$NPM_PACKAGES/bin"
export MANPATH="$NPM_PACKAGES/share/man:$MANPATH"

# Python (pip)
if [ $(uname -s) = "Darwin" ]; then
	export PATH="$PATH:$HOME/Library/Python/2.7/bin"
fi

# Python (virtualenvwrapper)
if [ -f "$HOME/.local/bin/virtualenvwrapper.sh" ]; then
	. "$HOME/.local/bin/virtualenvwrapper.sh"
fi

# ag (tag) -- Generate shell aliases for matches
if (( $+commands[tag] )); then
	tag() { command tag "$@"; source ${TAG_ALIAS_FILE:-/tmp/tag_aliases} 2>/dev/null }
	alias ag=tag
fi

# Rust
if [ -f "$HOME/.cargo/env" ]; then
	source "$HOME/.cargo/env"
fi
# }}}

# oh-my-zsh configuration & bootstrapping {{{
export ZSH="$HOME/.oh-my-zsh"

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

# Update without asking
DISABLE_UPDATE_PROMPT=true

ZSH_THEME="candy"
ZSH_CUSTOM="$HOME/.zsh-custom"

# Enabled Plugins
plugins=(git golang composer pip virtualenvwrapper tpm)

source "$ZSH/oh-my-zsh.sh"

# System-specific private config
[[ -f "$HOME/.zshrc_local" ]] && source "$HOME/.zshrc_local"
# }}}

# Custom aliases and functions {{{
# Load Yubikey into ssh-agent
function yk4() {
	# remove existing Yubikey from ssh-agent if loaded
	[ $(ssh-add -L | grep libykcs11 | wc -l) -ne 0 ] && ssh-add -e /usr/lib/libykcs11.so
	# load Yubikey
	ssh-add -s /usr/lib/libykcs11.so
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

# Use current path as new GOPATH, and include the bin in PATH
function gohere () {
	export PATH="$(pwd)/bin:$PATH"
	export GOPATH="$(pwd)"
}
# }}}
# vim: foldmethod=marker:foldlevel=0
