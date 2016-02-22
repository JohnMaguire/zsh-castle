# If tpm is installed, nothing to do
[ ! -d "$HOME/.tmux/plugins/tpm" ] || return 0

echo "tpm (tmux plugin manager) is not installed -- installing it!"

# Make sure Git is available
command -v git >/dev/null 2>&1 || {
		echo "Git is not installed -- can't install tpm"
		return 1
	}

# Clone tpm
env git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || {
	echo "Failed cloning tmux plugin manager -- can't install tpm"
	return 1
}
