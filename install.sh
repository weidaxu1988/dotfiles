#!/bin/sh
# Symlink the tracked configs into place. Idempotent -- safe to re-run, and
# re-running is how you verify. `./install.sh --check` reports without touching
# anything.
#
# Only single files are linked, never directories: fish rewrites
# fish_variables itself and ~/.config/fish/conf.d holds machine-local secrets,
# so those must stay outside the repo.
set -eu

DOTFILES=$(cd "$(dirname "$0")" && pwd)
CHECK=${1:-}

# <repo path>:<target>
LINKS="
zsh/zshenv:$HOME/.zshenv
zsh/zprofile:$HOME/.zprofile
zsh/zshrc:$HOME/.zshrc
git/gitconfig:$HOME/.gitconfig
fish/config.fish:$HOME/.config/fish/config.fish
ghostty/config:$HOME/.config/ghostty/config
"

fail=0
for pair in $LINKS; do
	src="$DOTFILES/${pair%%:*}"
	dst="${pair#*:}"

	if [ "$CHECK" = "--check" ]; then
		if [ "$(readlink "$dst" 2>/dev/null)" = "$src" ]; then
			echo "ok      $dst"
		else
			echo "WRONG   $dst"
			fail=1
		fi
		continue
	fi

	mkdir -p "$(dirname "$dst")"
	# Move a real file aside rather than clobbering it; a symlink we own or a
	# stale one just gets replaced.
	if [ -e "$dst" ] && [ ! -L "$dst" ]; then
		mv "$dst" "$dst.bak-$(date +%Y%m%d%H%M%S)"
		echo "backed up existing $dst"
	fi
	ln -sfn "$src" "$dst"
	echo "linked  $dst"
done

[ "$CHECK" = "--check" ] && exit $fail

# Machine-local files the repo deliberately does not carry.
[ -f "$HOME/.config/secrets.zsh" ] || echo "MISSING ~/.config/secrets.zsh (see zsh/README.md)"
[ -f "$HOME/.config/fish/conf.d/claude-secret.fish" ] || echo "MISSING ~/.config/fish/conf.d/claude-secret.fish"

echo
echo "Homebrew dependencies:"
echo "  brew install starship zsh-autosuggestions zsh-syntax-highlighting pyenv node && brew pin node"
