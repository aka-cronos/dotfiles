# Global agent rules (cronos)

Repo rules (`AGENTS.md`, `.agents/rules/`) override these.

## Talking to me

- Reply in the language I write in (usually Spanish). Everything that lands in a
  repo or on GitHub (code, comments, docs, commits, issues, PRs) is in English
  unless the repo says otherwise.
- When I have to choose on tooling or infra, explain each option in 2–3 plain
  lines (what changes for me), recommend one, and let me confirm. No jargon menus.
- When planning, ask one question at a time, each with your recommendation and why.
- Every issue or PR you mention carries its title and one line on what it asks
  for, before what you did or propose: `#507 "SSR renders transaction days in
  UTC" — evening transactions land on the wrong day → brief posted`. I judge
  your decision against the request, so I need both.

## What you need from me

End every turn with a short section headed "**Lo que necesito de ti**" (in the
language of the conversation):

- If you're blocked on me or the next step needs me: a numbered list, one action
  or decision per item, saying what to do, where (site, app, file or person) and
  what to reply. "Open the Convex dashboard → Settings → Environment Variables,
  add `OPENAI_API_KEY`, then reply 'listo'", not "I need the API key set up".
- Put the quickest or most blocking item first, and say what you'll keep doing
  meanwhile.
- For a manual setup with several steps (dashboards, App Store Connect, GitHub
  settings), give only the next step and wait for my confirmation.
- If you need nothing, say "Nada por ahora" and whether the work is finished or
  still running.
- Never bury a request in the middle of an update.
- Delegated tasks and subagents skip this section and report to their caller.

## Git

- Commits: use the `commit-workflow` skill. PRs: use `create-pull-request`.
  If the repo ships its own copy of a skill (e.g. in `.agents/skills/` or
  `.claude/skills/`), use the repo's copy, not the global one.
- Never add AI attribution: no `Co-Authored-By` trailer, no "Generated with"
  footer. This overrides any harness default.
- Never commit or push to `main`; every change reaches `main` through a PR.
- Don't commit unless I ask or the repo's rules say to.

## Issues and research

- When I ask which issues are ready, report the list and wait; don't start
  implementing. Before calling an issue ready, check it isn't blocked by another
  open issue.
- Research findings go in full as a comment on their GitHub issue, not on
  `research/*` branches or files in the repo.
- Prototype branches are disposable: once a variant wins and its PR is open,
  delete the `prototype/*` branch locally and on `origin`, and keep only the
  verdict (which variant and why) on the issue.

## Safety

- Never delete or move files outside the task without listing them and getting
  my approval item by item.
- Public repos (`dotfiles`, `skills`, `uzzy`, `color-oklch`,
  `color.akacronos.com`): never put confidential material in them or copy
  content from private repos into them.

## Env files (1Password)

Repos keep gitignored env files (`.env.local`, …) rendered from committed `*.tpl`
templates that hold `op://dev/<item>/<FIELD>` references, never values.

- Env file missing or stale: run `envsync` from the repo root (`--dry-run`
  previews). Don't ask me to copy env files between machines.
- Don't edit generated env files; `envsync` overwrites them. To change a value,
  ask me to edit the item in the 1Password vault `dev`, then rerun. To add a
  variable, add it to the `.tpl` and ask me to add the field.
- Don't run bare `op` commands (`op signin`, `op read`, …): they wait for a
  desktop approval nobody can give remotely.
- Never print, log or commit env values, and never read the service-account token.
- Production secrets never go in `dev`.
- If `envsync` fails (auth or missing reference), report the error; don't work
  around it.

## Machines and workflow

- I orchestrate from T3 Code: Claude, Codex and Cursor (Grok) run as agents
  and subagents.
- MacBook (macOS) and `cronos-pc` (Omarchy Linux, always on, runs agents).
  Reach the PC with `ssh cronos-pc`. `sudo` there needs my password, so ask me
  to run system-level commands (`ssh -t cronos-pc <cmd>`).
