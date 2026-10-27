# claude-agy

Kit for working with **Claude Code as the executor** and **Gemini (Antigravity CLI, `agy`) as a read-only reviewer**, using a Google AI Pro plan.

## What's inside

| Piece | What it does |
|---|---|
| `bin/agy-ask` | Wrapper around `agy -p`: runs Gemini headless against the repo, saves the answer to `.agy/*.md`, and **exits with code 3 if the repo changed** while Gemini was running. |
| `bin/agy-stack` | Detects the repo's stack (Rails, Python, Astro, openFrameworks, JUCE) and copies its rubric to `.agy/rubric.md`. Every command uses it. |
| `bin/agy-claudemd` | Adds or refreshes the claude-agy section in the project's `CLAUDE.md`. Safe to run repeatedly. |
| `/gemini-plan-review` | Gemini reviews a plan in `plans/` against the real code. Claude verifies every finding, updates the plan and leaves architecture decisions to you. |
| `/gemini-review` | Cross-model review at the end of every feature (diff against `main`). Claude verifies, fixes critical/major findings, runs the checks and reports. |
| `/gemini-audit` | Whole-repo audit, slice by slice, against the stack's rubric. Leaves a prioritized backlog in `plans/audit-<date>.md`. Fixes nothing. |
| `/gemini-research` | Gemini researches the live web (libraries, SDKs, APIs, breaking changes) for the versions this repo actually uses, with sources. |
| `/gemini-digest` | Gemini reads PDFs, screenshots, videos or heavy folders and writes a faithful markdown digest. Claude works from the digest. |
| `rubrics/*.md` | One rubric per stack: principles, audit slices, review focus and verification commands. For a single repo, create `.claude/agy-rubric.md` and it takes precedence. |
| `CLAUDE.md.snippet` | Workflow rules for each project's `CLAUDE.md` (inserted by `agy-claudemd`). |

## Installation (once)

1. Install Antigravity CLI and sign in with your AI Pro account:
   ```bash
   curl -fsSL https://antigravity.google/cli/install.sh | bash
   agy          # sign in with Google, then exit with /quit
   agy --help   # confirm -p, --output-format, --add-dir and --print-timeout exist
   ```
2. Install the kit. It creates symlinks, so the source stays in `~/.config/claude-agy` and is versioned with your dotfiles:
   ```bash
   bash ~/.config/claude-agy/install.sh
   git --git-dir=$HOME/.dotfiles --work-tree=$HOME add ~/.config/claude-agy
   git --git-dir=$HOME/.dotfiles --work-tree=$HOME commit -m "Add claude-agy kit"
   ```
3. If it warns that `~/.local/bin` is not in PATH, add it to your `.zshrc`.
4. Quick test from any repo:
   ```bash
   agy-ask "In one line, what does this repository do?"
   ```
   It prints the path of the `.md` with the answer. If you get the empty-answer error, try `AGY_ASK_PTY=1 agy-ask "..."` (some `agy` builds drop stdout when called from another program). If that works, add `export AGY_ASK_PTY=1` to your `.zshrc`.

## Per project

1. From the project root:
   ```bash
   agy-claudemd     # adds/refreshes the section in CLAUDE.md
   mkdir -p plans
   agy-stack        # confirm the detected stack
   ```
2. Edit the `Checks:` line in `CLAUDE.md` if the project builds or tests differently from its rubric's defaults.
3. If `agy-stack` says `ambiguous`, create `.claude/agy-rubric.md` (copy a rubric from the kit and adapt it), or pick one when Claude asks.
4. Done. The `.agy/` folder is created automatically and excluded from git locally (`.git/info/exclude`), without touching your `.gitignore`.

## Daily flow

| Situation | What you do |
|---|---|
| Small feature | Claude plans and implements directly. At the end: `/gemini-review`. |
| Big or architectural feature | Plan mode → Claude saves the plan in `plans/` → `/gemini-plan-review plans/<file>.md` → answer the NEEDS PAUL items → Claude implements → `/gemini-review`. |
| About to use a library/API that changed recently | `/gemini-research <question>` before implementing. |
| A client PDF, brief or video arrives | `/gemini-digest path/to/file "what to extract"`. |
| Existing repo joining the workflow | `/gemini-audit` once → answer "Decisions for Paul" → implement the backlog one batch per branch, each closed with `/gemini-review`. |

Rules the kit enforces: Gemini never writes, Claude verifies every finding against `path:line` evidence, you decide architecture, tests and builds decide behavior, one review round per feature.

## Stacks and rubrics

| Stack | Detected by | Primary lens |
|---|---|---|
| `rails` | `Gemfile` + `config/application.rb` | Rails Way (DHH / 37signals), SOLID adapted |
| `python` | `pyproject.toml`, `requirements.txt`, `setup.py`, `Pipfile` | Simple, Pythonic code; bot/API integration safety |
| `astro` | `astro.config.*` | Zero JS by default, islands only where needed |
| `openframeworks` | `addons.make`, `src/ofApp.cpp` | Frame-rate safety, clear resource ownership |
| `juce` | `*.jucer`, `juce_add_*` in `CMakeLists.txt` | Realtime audio-thread safety, thread ownership |

`agy-stack -l` lists rubrics; `agy-stack -s <stack>` forces one.

## `agy-ask` options

```
agy-ask [-o out.md] [-f prompt.md] [-d extra_dir]... [-m model] [-t 10m] ["prompt"]
```

- `AGY_ASK_MODEL`: default model (see available IDs with `/model` inside `agy`).
- `AGY_ASK_TIMEOUT`: max wait, default `10m`.
- `AGY_ASK_PTY=1`: empty-stdout workaround.

Exit codes: `0` ok, `1` usage error, `2` Gemini returned nothing, `3` the repo changed during the run.

## Failure modes handled (v0.2)

- **Denied command** (agy ran something outside `permissions.allow`): agy discards the whole turn and returns `response: ""` in ~5s. `agy-ask` now resumes the same conversation (`--conversation <id>`) and forces a final answer without commands.
- **Print timeout** (10m, turn still exploring): same empty response. Same resume, 5m per try, forces an answer from what was read.
- Tune with `AGY_ASK_RESUMES` (3), `AGY_ASK_RESUME_TIMEOUT` (5m), `AGY_ASK_EFFORT` (lower = faster). Avoid `--mode plan` (writes plan files outside the repo).

## Known limitations

- Tested against a simulated `agy`, not the real one. Flags come from the Antigravity CLI docs as of September 2026. The tool changes fast: if something fails, `agy --help` wins.
- The read-only lock is twofold: the prompt forbids writing and the wrapper detects any change in the repo. It never uses `--dangerously-skip-permissions`, so `agy` has no automatic permission to write files or run commands. Anything outside the repo is not monitored.
- AI Pro quota refreshes every 5 hours up to a weekly cap. `/gemini-review` on a huge diff and `/gemini-audit` on a big repo burn through it quickly: review per feature, audit per slice.
