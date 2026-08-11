# zsh config (iCloud-synced)

Three files, split by when zsh reads them:

| File | Read by | Holds |
|---|---|---|
| `zshenv` | every zsh, including scripts and `ssh host 'cmd'` | nothing — kept empty on purpose |
| `zprofile` | login shells, after `/etc/zprofile` | all environment variables and `PATH` |
| `zshrc` | interactive shells | prompt, aliases, completion, plugins |

`PATH` lives in `zprofile` rather than `zshenv` because macOS runs
`/usr/libexec/path_helper` from `/etc/zprofile`, which rebuilds `PATH` from
`/etc/paths` and appends whatever was already set — anything prepended in
`zshenv` ends up at the back of `PATH`.

Consequence: a non-login, non-interactive shell (`ssh host 'cmd'`) gets no
custom environment at all. Ask for a login shell when you need one:

```sh
ssh host 'zsh -lc "kubectl get pods"'
```

## Setup on a new machine

```sh
ICLOUD=~/Library/Mobile\ Documents/com~apple~CloudDocs/.config/zsh
ln -sfn "$ICLOUD/zshenv"   ~/.zshenv
ln -sfn "$ICLOUD/zprofile" ~/.zprofile
ln -sfn "$ICLOUD/zshrc"    ~/.zshrc
```

If `~/.zprofile` already exists as a real file, `ln -sfn` replaces it — check
first that it holds nothing you still need.

Dependencies, all from Homebrew. Nothing is vendored into
`~/.oh-my-zsh/custom/`; both plugin lines guard on the file being present, so
a missing install degrades quietly instead of erroring on every prompt.

```sh
brew install starship zsh-autosuggestions zsh-syntax-highlighting pyenv nvm
```

`zshrc` sources `zsh-syntax-highlighting` last: it wraps every ZLE widget
defined before it and misses any defined after.

## Secrets are NOT here

Tokens live in `~/.config/secrets.zsh` (mode 600, local only, never synced).
`zprofile` sources it if present. Recreate by hand on each machine:

```sh
cat > ~/.config/secrets.zsh <<'EOF'
export GITHUB_PERSONAL_ACCESS_TOKEN="..."
export ANTHROPIC_AUTH_TOKEN="..."
EOF
chmod 600 ~/.config/secrets.zsh
```

## Sibling configs under the same iCloud `.config/`

- `fish/` — only `config.fish` is synced. Symlink that one file, not the
  directory: fish rewrites `fish_variables` itself (`set -U`), and `conf.d/`
  is where the machine-local fish copy of the secrets lives.
- `ghostty/` — only the `config` file, same reasoning.

Git config is deliberately not synced: identity differs per machine.
