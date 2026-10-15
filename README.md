# dotfiles

Reproducible personal configuration for two machines: a Mac (zsh, Homebrew) and a desktop PC running [Omarchy](https://omarchy.org) (bash, pacman). What both use lives in `shared/`; each machine has its own folder and setup script.

```
dotfiles/
├── shared/              # used by both machines; shared/install.sh links it
│   ├── agents/          # agent rules, Claude Code settings, global skills, envsync
│   ├── git/             # gitconfig, global ignore; allowed_signers is local only
│   ├── mise/            # toolchain: node, pnpm, gh, claude, codex, cursor-agent
│   └── shell/           # aliases.sh, sourced by zsh (Mac) and bash (PC)
├── mac/                 # bootstrap.sh, Brewfile, zsh, p10k, ghostty, ssh, git signing
├── omarchy/             # install.sh, README (sudo steps), bash additions, prompt,
│                        # hypr, agents-panel collector, Codex patch, git signing
└── themes/              # saved app themes (Oscura for Omarchy and T3 Code)
```

## Setup

### Mac

Requirements: `git` and the Xcode Command Line Tools (`xcode-select --install`).

```sh
git clone https://github.com/aka-cronos/dotfiles.git ~/Documents/Code/dotfiles
~/Documents/Code/dotfiles/mac/bootstrap.sh
```

It installs Homebrew and the `Brewfile` (apps, fonts, base CLIs), links the Mac config, clones the zsh plugins, then runs `shared/install.sh mac`. It ends with the manual steps (1Password, `gh auth login`, `allowed_signers`, `ssh/config.local`).

### PC (Omarchy)

```sh
git clone https://github.com/aka-cronos/dotfiles.git ~/Code/dotfiles
~/Code/dotfiles/omarchy/install.sh
```

It runs every step that does not need sudo, including `shared/install.sh omarchy`. Packages, sudo steps and sign-ins are in [`omarchy/README.md`](omarchy/README.md).

Both scripts are idempotent and back up any real file they replace into `~/.dotfiles-backup-<timestamp>/`.

## Shared config

`shared/install.sh <mac|omarchy>` links:

- **Git**: `shared/git/gitconfig` as `~/.config/git/config` (identity, defaults, `gh` credentials). It includes `~/.config/git/machine`, linked to `<machine>/git/machine`, which holds the signing key: 1Password on the Mac, a key on disk on the PC so agents can sign unattended.
- **mise**: `shared/mise/config.toml`, then `mise install`. `mise up` updates everything. Projects with `.nvmrc` or `.node-version` pick their own Node.
- **Shell**: `shared/shell/aliases.sh` (git aliases, `code` for Cursor, open new shells in the code folder). Keep it valid in both zsh and bash.
- **Agents**: `shared/agents/install.sh`, see below.

## Agents

- `shared/agents/AGENTS.md` is the global rule file, linked as `~/.agents/AGENTS.md`. Each agent's global file links there: `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md`. Cursor has no global rule file, so it only follows each repo's `AGENTS.md`. Repo rules override it.
- `shared/agents/claude/` holds Claude Code's `settings.json` and status line script.
- `shared/agents/skills.txt` lists the global skills; the script installs any that are missing into `~/.agents/skills`, which Claude Code, Codex and Cursor all read. `skills-catalog.md` records every skill removed in the 2026-10-14 cleanup and how to reinstall it.
- `shared/agents/bin/envsync` renders a repo's env files from 1Password templates (`~/.local/bin/envsync`).

Claude Code may rewrite `~/.claude/settings.json` (for example after `/config`). If `ls -la ~/.claude/settings.json` no longer shows a symlink, copy the changes you want into `shared/agents/claude/settings.json` and rerun the script.

## Editing

The machines symlink back to this repo, so edit the files in here; the repo is the source of truth. Commit the change as usual and pull on the other machine. New files or links need the setup script rerun.

## What is left out (on purpose)

`gh` configuration and Codex's `config.toml` (machine-specific project trust and plugins) are managed separately.
