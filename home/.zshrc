# Homeshick (dotfile management) {{{
if [ -f "$HOME/.homesick/repos/homeshick/homeshick.sh" ]; then
	source "$HOME/.homesick/repos/homeshick/homeshick.sh"
	fpath=("$HOME/.homesick/repos/homeshick/completions" $fpath)
fi
# }}}

# oh-my-zsh configuration {{{
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
plugins=(git golang composer pip neovim virtualenvwrapper tpm)

# These should be pretty standard, we'll customize later
export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/bin"
export MANPATH="/usr/local/man"

source "$ZSH/oh-my-zsh.sh"
# }}}

# Shell Environment Variables (EDITOR, LANG, etc.) {{{
export LANG=en_US.UTF-8

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
# export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
# }}}

# vim: foldmethod=marker:foldlevel=0
