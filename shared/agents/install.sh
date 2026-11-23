#!/usr/bin/env bash
# Agent setup for macOS and Linux (Omarchy).
# Rules, Claude Code settings and global skills live in the private repo
# aka-cronos/agent-process; this script links envsync and runs its installer.
# Idempotent: safe to run as many times as needed.
# Portable to macOS's bash 3.2 and BSD userland.
set -euo pipefail

AGENTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=shared/lib.sh
source "$(dirname "$AGENTS_DIR")/lib.sh"

# ---------------------------------------------------------------------------
# 1. Helpers
# ---------------------------------------------------------------------------
link_file "$AGENTS_DIR/bin/envsync" "$HOME/.local/bin/envsync"

# ---------------------------------------------------------------------------
# 2. Rules, Claude Code settings and skills, from agent-process
# ---------------------------------------------------------------------------
if [[ -d "$HOME/Documents/Code" ]]; then
  CODE_DIR="$HOME/Documents/Code"
else
  CODE_DIR="$HOME/Code"
fi
AGENT_PROCESS="$CODE_DIR/agent-process"

if [[ ! -d "$AGENT_PROCESS/.git" ]]; then
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    log "Cloning agent-process into $AGENT_PROCESS"
    gh repo clone aka-cronos/agent-process "$AGENT_PROCESS"
  else
    log "agent-process is missing: sign in with 'gh auth login', then rerun"
    exit 0
  fi
fi

"$AGENT_PROCESS/scripts/install.sh"
