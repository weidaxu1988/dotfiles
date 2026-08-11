# dotfiles

Shell and terminal config for two machines. Git is the single source of truth
— nothing here is synced through iCloud.

```sh
git clone <url> ~/dotfiles
~/dotfiles/install.sh
brew install starship zsh-autosuggestions zsh-syntax-highlighting pyenv node && brew pin node
```

`install.sh --check` verifies the links without changing anything.

## What is linked

| Repo file | Target |
|---|---|
| `zsh/zshenv` | `~/.zshenv` |
| `zsh/zprofile` | `~/.zprofile` |
| `zsh/zshrc` | `~/.zshrc` |
| `git/gitconfig` | `~/.gitconfig` |
| `fish/config.fish` | `~/.config/fish/config.fish` |
| `ghostty/config` | `~/.config/ghostty/config` |

Single files only, never whole directories. `~/.config/fish/` also holds
`fish_variables` (which fish rewrites itself on every `set -U`) and
`conf.d/claude-secret.fish` (a credential) — neither belongs in a repo.

## What stays machine-local

Not tracked, not synced, recreated by hand on each machine:

| File | Holds | Mode |
|---|---|---|
| `~/.config/secrets.zsh` | `GITHUB_PERSONAL_ACCESS_TOKEN`, `ANTHROPIC_AUTH_TOKEN` | 600 |
| `~/.config/fish/conf.d/claude-secret.fish` | same token, for fish | 600 |

`install.sh` warns if either is missing.

Git identity is the same on both machines, so it is tracked in
`git/gitconfig` rather than split out. If that ever stops being true, add
`[includeIf "gitdir:..."]` instead of un-tracking it.

## zsh layout

Three files, split by when zsh reads them. See `zsh/README.md` for why `PATH`
has to be in `zprofile` rather than `zshenv` on macOS.

| File | Read by | Holds |
|---|---|---|
| `zshenv` | every zsh, incl. scripts and `ssh host 'cmd'` | nothing, kept empty |
| `zprofile` | login shells | environment variables and `PATH` |
| `zshrc` | interactive shells | prompt, aliases, completion, plugins |

Prompt is starship. Plugins come from Homebrew, nothing is vendored into
`~/.oh-my-zsh/custom/`.
