#!/usr/bin/env bash
# Agent config (Claude Code, Codex, Cursor) for macOS and Linux (Omarchy).
# Idempotent: safe to run as many times as needed.
# Portable to macOS's bash 3.2 and BSD userland.
set -euo pipefail

AGENTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"

log() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }

link_file() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"

  if [[ -e "$dst" && ! -L "$dst" ]]; then
    log "Backing up $dst -> $BACKUP_DIR/"
    mkdir -p "$BACKUP_DIR"
    mv "$dst" "$BACKUP_DIR/"
  fi

  ln -sfn "$src" "$dst"
  log "Symlink: $dst -> $src"
}

# ---------------------------------------------------------------------------
# 1. Global rules: ~/.agents/AGENTS.md, shared by every agent's global file
# ---------------------------------------------------------------------------
link_file "$AGENTS_DIR/AGENTS.md" "$HOME/.agents/AGENTS.md"
link_file "$HOME/.agents/AGENTS.md" "$HOME/.claude/CLAUDE.md"
link_file "$HOME/.agents/AGENTS.md" "$HOME/.codex/AGENTS.md"

# ---------------------------------------------------------------------------
# 2. Claude Code settings and status line
# ---------------------------------------------------------------------------
link_file "$AGENTS_DIR/claude/settings.json" "$HOME/.claude/settings.json"
link_file "$AGENTS_DIR/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"

# ---------------------------------------------------------------------------
# 3. Helpers
# ---------------------------------------------------------------------------
link_file "$AGENTS_DIR/bin/envsync" "$HOME/.local/bin/envsync"

# ---------------------------------------------------------------------------
# 4. Global skills (shared store ~/.agents/skills, read by all agents)
# ---------------------------------------------------------------------------
if command -v npx >/dev/null 2>&1; then
  grep -v '^#' "$AGENTS_DIR/skills.txt" | while read -r source skills; do
    [[ -n "$source" ]] || continue
    for skill in $skills; do
      if [[ -d "$HOME/.agents/skills/$skill" ]]; then
        log "Skill already installed: $skill"
      else
        log "Installing skill: $skill ($source)"
        npx -y skills add "$source" --skill "$skill" -g -y </dev/null
      fi
    done
  done
else
  log "npx not found: skipping skills (install Node with mise, then rerun)"
fi

cat <<'EOF'

==> Agent config installed. Cursor has no global rule file: it follows
    each repo's AGENTS.md and reads the skills from ~/.agents/skills.

EOF
