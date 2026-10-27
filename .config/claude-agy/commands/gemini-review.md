---
description: End-of-feature cross-model code review by Gemini (agy), read-only, using the stack's rubric. Claude verifies the findings, fixes the real ones and runs the project's checks.
argument-hint: [base-branch] (default: main)
allowed-tools: Bash(agy-ask:*), Bash(agy-stack:*), Bash(git diff:*), Bash(git merge-base:*), Bash(git rev-parse:*), Bash(git ls-files:*), Bash(git log:*), Bash(git status:*), Bash(mkdir:*), Bash(bin/rails:*), Bash(bin/rubocop:*), Bash(bin/brakeman:*), Bash(uv run:*), Bash(pytest:*), Bash(python -m pytest:*), Bash(ruff:*), Bash(npm run:*), Bash(npm test:*), Bash(npx astro:*), Bash(make:*), Bash(cmake:*), Bash(ctest:*), Bash(xcodebuild:*), Read, Write, Edit, Grep, Glob
---

Base branch: $ARGUMENTS (if empty, use `main`; if `main` does not exist, use `master`).

## 1. Stack and rubric

Run `agy-stack`. Exit 0: the rubric is at `.agy/rubric.md`. Exit 4: ask me which stack, then `agy-stack -s <stack>`. Exit 5: continue without a rubric and tell me at the end.

## 2. Snapshot the change

1. `BASE=$(git merge-base <base> HEAD)`
2. `git diff $BASE --output=.agy/diff.patch` (includes uncommitted changes to tracked files). Use `--output`, never `>`: the RTK hook rewrites `git diff > file` into a compact summary, not a patch. Check that the file starts with `diff --git`.
3. `git ls-files -o --exclude-standard` lists new untracked files. Keep that list.
4. If the diff is empty and there are no new files, stop and tell me there is nothing to review.
5. Look in `plans/` for the plan of this feature (match by name or by the files it touches).

## 3. Build the prompt

Write `.agy/code-review.prompt.md`, filling the bracketed parts:

```
Review the change in .agy/diff.patch. [If there are new untracked files: Also read these new files, they are part of the change: <list>.] [If a plan exists: The intended design is described in <plan path>; flag deviations from it.] [If a rubric exists: Apply .agy/rubric.md, especially its "Review focus" section, and cite rule ids.]

Read the surrounding code as needed to judge the change in context. Report:
1. Bugs and wrong behavior.
2. Security issues.
3. Performance, data safety and, for realtime/audio/graphics code, anything that can glitch, block or crash.
4. Tests: behavior in the diff that has no test, or tests that do not exercise the change.
5. Fit: places where the change fights the conventions of this codebase or the rubric, or adds abstractions the problem does not need.

For each finding: severity (critical / major / minor), path:line, what is wrong, and a concrete fix.
Maximum 15 findings, most severe first. If the change is clean, say "No significant findings".
```

## 4. Run Gemini

Run: `agy-ask -o .agy/code-review.md -f .agy/code-review.prompt.md`

- Exit 3: the repo changed during the review. Stop, tell me, touch nothing.
- Exit 2 with a hint about `AGY_ASK_PTY=1`: retry once with that env var set.
- Any other failure: show me the error and stop.

## 5. Verify, then fix

For each finding, open the code and classify it ACCEPTED, REJECTED (one-line reason) or NEEDS PAUL (architecture, product or policy call). A finding you cannot confirm in the code is REJECTED.

- Fix ACCEPTED critical and major findings. Add or adjust tests where the finding is about behavior and the project has tests.
- Run the checks: use the "Verification" commands from the project's CLAUDE.md if it defines them, otherwise the "Verification" section of `.agy/rubric.md`. If a check fails, fix it or report it. For projects without automated tests, give me the manual smoke test from the rubric, adapted to this change.
- Do not fix minor findings: list them for me.
- Do not touch anything classified NEEDS PAUL.

## 6. Report

Reply in English, in this order: NEEDS PAUL items as direct questions; fixes applied (one line each); minor findings left as is; rejected findings with the reason; check results (or the manual smoke test).

One round only. Do not send the result back to Gemini unless I ask.
