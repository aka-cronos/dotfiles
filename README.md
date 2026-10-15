# dotfiles

Reproducible personal configuration: shell (zsh + Powerlevel10k), Ghostty and git. Meant to take a freshly formatted Mac to fully operational with a clone + one script.

The Linux desktop (Omarchy) is not covered by the script; its changes are documented in [`omarchy/`](omarchy/README.md).

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
- Create `git/allowed_signers`. It stays in this folder (bootstrap symlinks `~/.config/git/allowed_signers` to it) and is gitignored, so commit emails are not published. One line: the address in `user.email`, then the public key from `user.signingkey` in `git/gitconfig`. Add older addresses on the same line, comma-separated, only if you still want `git` to verify commits signed with them.

  ```
  you@example.com ssh-ed25519 AAAA...
  ```

- Optional: create `ssh/config.local` for private machines. Like `allowed_signers`, it stays in this folder (bootstrap symlinks `~/.ssh/config.local` to it) and is gitignored, so host names and private addresses are not published. `ssh/config` loads it with `Include`, and a missing file is ignored. Use plain `Host` blocks:

  ```
  Host my-pc
    HostName my-pc.local
    User me
  ```

- Open each installed app once to grant system permissions.
- In Cursor > Settings > Agents, keep "Include Third-Party Plugins, Skills, and Other Configs" on: that is how Cursor picks up `~/.claude/CLAUDE.md` and the global skills.

## Repo structure

```
dotfiles/
├── bootstrap.sh    # install + symlinks, idempotent
├── Brewfile        # CLIs, casks and fonts installed via Homebrew
├── zsh/            # zshrc, zprofile and the ~/.config/zsh modules
├── p10k/           # Powerlevel10k theme (p10k.zsh)
├── ghostty/        # Ghostty terminal config
├── git/            # gitconfig, global git ignore; allowed_signers is local only
├── ssh/            # ssh config; config.local (private hosts) is local only
├── agents/         # agent rules, Claude Code settings, global skills; install.sh (Mac and Linux)
├── omarchy/        # customizations for the Omarchy desktop PC, applied by hand
└── themes/         # saved app themes (Oscura for Omarchy and T3 Code), installed by hand
```

## How to edit the configuration

The system symlinks back to this repo (links are created by `bootstrap.sh`), so to change any config **edit the file in here**, not the symlink target — they are the same file, but the repo is the source of truth. After editing, commit the change as usual.

## Agents

`agents/install.sh` (run by `bootstrap.sh`, or by hand on the PC) sets up the coding agents the same way on both machines:

- `agents/AGENTS.md` is the global rule file for every agent: linked as `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md`; Cursor imports the Claude file through its third-party configs setting. Repo rules override it.
- `agents/claude/` holds Claude Code's `settings.json` and status line script.
- `agents/skills.txt` lists the global skills; the script installs any that are missing into `~/.agents/skills`, which Claude Code, Codex and Cursor all read. `agents/skills-catalog.md` records every skill removed in the 2026-10-14 cleanup and how to reinstall it.
- `agents/bin/envsync` renders a repo's env files from 1Password templates (`~/.local/bin/envsync`).

Claude Code may rewrite `~/.claude/settings.json` (for example after `/config`). If `ls -la ~/.claude/settings.json` no longer shows a symlink, copy the changes you want into `agents/claude/settings.json` and rerun the script.

## What is left out (on purpose)

`gh` configuration and Codex's `config.toml` (machine-specific project trust and plugins) are managed separately.
