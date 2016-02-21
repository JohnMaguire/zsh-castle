# Homeshick (dotfile management) {{{
if [ -f "$HOME/.homesick/repos/homeshick/homeshick.sh" ]; then
	source "$HOME/.homesick/repos/homeshick/homeshick.sh"
	fpath=("$HOME/.homesick/repos/homeshick/completions" $fpath)
fi
# }}}

# oh-my-zsh configuration {{{
# Path to your oh-my-zsh installation.
export ZSH=/home/jmaguire/.oh-my-zsh

# Install oh-my-zsh if it is not already installed
[ -d $ZSH ] || sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Update without asking
DISABLE_UPDATE_PROMPT=true

ZSH_THEME="candy"
ZSH_CUSTOM="$HOME/.zsh-custom"

plugins=(git golang composer pip neovim)

# These should be pretty standard, we'll customize later
export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin"
export MANPATH="/usr/local/man"

source $ZSH/oh-my-zsh.sh
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

# PHP (composer)
export COMPOSER_HOME="$HOME/.composer"
export PATH="$PATH:$COMPOSER_HOME/vendor/bin"

# Ruby (RubyGems)
export PATH="$PATH:$HOME/.gem/ruby/2.2.0/bin"

# Python (virtualenvwrapper)
export WORKON_HOME="$HOME/.virtualenvs"
[ -f /usr/bin/virtualenvwrapper.sh ] && source /usr/bin/virtualenvwrapper.sh

# Javascript (node / npm)
export NPM_PACKAGES="$HOME/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
export PATH="$PATH:$NPM_PACKAGES/bin"
# export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
# }}}

# vim: foldmethod=marker:foldlevel=0
