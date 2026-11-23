# dotfiles

Reproducible personal configuration for two machines: a Mac (zsh, Homebrew) and a desktop PC running [Omarchy](https://omarchy.org) (bash, pacman). What both use lives in `shared/`; each machine has its own folder and setup script.

```
dotfiles/
├── shared/              # used by both machines; shared/install.sh links it
│   ├── agents/          # envsync, and the call to agent-process's installer
│   ├── git/             # gitconfig, global ignore; allowed_signers is local only
│   ├── mise/            # toolchain: node, pnpm, gh
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

Both scripts are idempotent and back up any real file they replace into `~/.dotfiles-backup-<timestamp>-<pid>/`, keeping its path under `$HOME`.

## Shared config

`shared/install.sh <mac|omarchy>` links:

- **Git**: `shared/git/gitconfig` as `~/.config/git/config` (identity, defaults, `gh` credentials). It includes `~/.config/git/machine`, linked to `<machine>/git/machine`, which holds the signing key: 1Password on the Mac, a key on disk on the PC so agents can sign unattended.
- **mise**: `shared/mise/config.toml`, then `mise install`. `mise up` updates everything. Projects with `.nvmrc` or `.node-version` pick their own Node. It also sets pnpm's global `minimum-release-age` to 1440 minutes, so pnpm won't install a version published less than a day ago.
- **Agent CLIs**: `claude`, `codex` and `cursor-agent` come from their official installers into `~/.local/bin` (skipped if already there). Each updates itself (`claude update`, `codex update`, `cursor-agent update`), and T3 Code can update Claude and Codex from its providers screen; it can't do that for tools installed by mise.
- **Shell**: `shared/shell/aliases.sh` (git aliases, `code` for Cursor, open new shells in the code folder). Keep it valid in both zsh and bash.
- **Agents**: `shared/agents/install.sh`, see below.

## Agents

- Global rules, Claude Code's settings and the global skills live in the private repo `aka-cronos/agent-process`, which installs them in Claude Code, Codex, Cursor and Antigravity. `shared/agents/install.sh` clones it into the code folder if it is missing and runs its `scripts/install.sh`. Its README says how to change a rule or a skill.
- `shared/agents/bin/envsync` renders a repo's env files from 1Password templates (`~/.local/bin/envsync`).

## Editing

The machines symlink back to this repo, so edit the files in here; the repo is the source of truth. Commit the change as usual and pull on the other machine. Rerun the setup script after adding files or links, and on the PC after changing `omarchy/systemd/` (those units are copied, not linked).

## What is left out (on purpose)

`gh` configuration and Codex's `config.toml` (machine-specific project trust and plugins) are managed separately.
