#!/bin/sh
# Claude Code statusLine command
# Mirrors the Powerlevel10k lean 8-color prompt style:
# dir [git-branch git-status] | model context%

input=$(cat)

cwd=$(echo "$input" | jq -r '.cwd')
model=$(echo "$input" | jq -r '.model.display_name')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Shorten the directory (replace $HOME with ~)
home="$HOME"
short_dir="${cwd/#$home/\~}"

# Git info (branch + dirty indicator) — skip optional locks
git_info=""
if git -C "$cwd" rev-parse --git-dir --no-optional-locks > /dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
           || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    # Count staged, unstaged, untracked
    staged=$(git -C "$cwd" --no-optional-locks diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
    unstaged=$(git -C "$cwd" --no-optional-locks diff --name-only 2>/dev/null | wc -l | tr -d ' ')
    untracked=$(git -C "$cwd" --no-optional-locks ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')

    git_info=" $branch"
    [ "$staged" -gt 0 ]    && git_info="$git_info +$staged"
    [ "$unstaged" -gt 0 ]  && git_info="$git_info !$unstaged"
    [ "$untracked" -gt 0 ] && git_info="$git_info ?$untracked"
  fi
fi

# Context window info
ctx_info=""
if [ -n "$remaining" ]; then
  ctx_info=" $(printf '%.0f' "$remaining")%"
fi

# Session rate-limit info (5-hour window) — show only when >= 70% used
session_segment=""
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_resets_at=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
if [ -n "$five_pct" ] && [ -n "$five_resets_at" ]; then
  five_pct_int=$(printf '%.0f' "$five_pct")
  if [ "$five_pct_int" -ge 70 ]; then
    now=$(date +%s)
    secs_left=$(( five_resets_at - now ))
    if [ "$secs_left" -lt 0 ]; then secs_left=0; fi
    hours_left=$(( secs_left / 3600 ))
    mins_left=$(( (secs_left % 3600) / 60 ))
    reset_str="${hours_left}h ${mins_left}m"
    # Choose color: red >= 90%, yellow >= 70%
    if [ "$five_pct_int" -ge 90 ]; then
      session_color='\033[31m'
    else
      session_color='\033[33m'
    fi
    session_segment=" ${session_color}5h: ${five_pct_int}% used (reset in ${reset_str})\033[0m"
  fi
fi

# Build output with ANSI colors (blue dir, green git, grey model/ctx)
# Blue for directory (color 4), green for git (color 2), dim for model
printf '\033[34m%s\033[0m' "$short_dir"
if [ -n "$git_info" ]; then
  printf '\033[32m%s\033[0m' "$git_info"
fi
printf ' \033[2m%s%s\033[0m' "$model" "$ctx_info"
if [ -n "$session_segment" ]; then
  printf "$session_segment"
fi
