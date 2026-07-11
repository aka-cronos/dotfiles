# dotfiles

Reproducible personal configuration: shell (zsh + Powerlevel10k), Ghostty and git. Meant to take a freshly formatted Mac to fully operational with a clone + one script.

## Requirements

- `git`
- Xcode Command Line Tools (`xcode-select --install`)

Everything else (Homebrew, packages, apps) is installed by `bootstrap.sh`.

## Setup on a new machine

```sh
git clone https://github.com/aka-cronos/dotfiles.git ~/Documents/Code/dotfiles
cd ~/Documents/Code/dotfiles
./bootstrap.sh
```

The script is idempotent: it installs Homebrew if missing, runs `brew bundle` against the `Brewfile`, creates the config symlinks (backing up any real file it finds in the way) and clones the zsh plugins.

### Manual steps after bootstrap

- Sign in to 1Password (app + `op` CLI).
- `gh auth login` for the GitHub CLI.
- Open each installed app once to grant system permissions.
- Install skills on demand with `npx skills add aka-cronos/skills -g` (or others, per project).

## Repo structure

```
dotfiles/
├── bootstrap.sh    # install + symlinks, idempotent
├── Brewfile        # CLIs, casks and fonts installed via Homebrew
├── zsh/            # zshrc, zprofile and the ~/.config/zsh modules
├── p10k/           # Powerlevel10k theme (p10k.zsh)
├── ghostty/        # Ghostty terminal config
└── git/            # gitconfig and global git ignore
```

## How to edit the configuration

The system symlinks back to this repo (links are created by `bootstrap.sh`), so to change any config **edit the file in here**, not the symlink target — they are the same file, but the repo is the source of truth. After editing, commit the change as usual.

## What is left out (on purpose)

Claude Code, Cursor and `gh` configuration does not live in this repo yet — they are candidates to be added later, but for now they are managed separately.
