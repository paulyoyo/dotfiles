---
description: Full-codebase audit by Gemini (agy), read-only, slice by slice, against the stack's rubric (Rails, Python, Astro, openFrameworks, JUCE or custom). Produces a prioritized backlog in plans/. Fixes nothing.
argument-hint: [all | slice name from the rubric, e.g. models, audio, components]
allowed-tools: Bash(agy-ask:*), Bash(agy-stack:*), Bash(mkdir:*), Bash(ls:*), Bash(find:*), Bash(wc:*), Bash(git ls-files:*), Bash(git log:*), Bash(bin/rails routes:*), Bash(bin/rails stats:*), Read, Write, Edit, Grep, Glob
---

Scope: $ARGUMENTS (empty means `all`).

This command audits and plans. It does NOT change application code.

## 1. Stack and rubric

Run `agy-stack`.

- Exit 0: note the `stack=` value. The rubric is now at `.agy/rubric.md`. Read it.
- Exit 4 (ambiguous, e.g. a Rails app with a Python helper folder): show me the candidates and ask which one. Then run `agy-stack -s <stack>`.
- Exit 5 (unknown): ask me which rubric to use (`agy-stack -l` lists them) or whether to write a custom `.claude/agy-rubric.md` first.

## 2. Inventory and slices

`mkdir -p .agy/audit`. Map the codebase with `git ls-files` and `wc -l` (plus `bin/rails stats` for Rails). Exclude vendored code, generated files, node_modules, build output, lockfiles' contents and binary assets. Write `.agy/audit/inventory.md`: main directories with line counts, the 10 largest source files, entry points, test setup, notable dependencies.

Use the **Slices** table from the rubric, mapped to the paths that actually exist here. Skip empty slices. If a slice exceeds roughly 8,000 lines, split it by subfolder or domain area.

If a specific slice was requested, run only that one. Otherwise show me the slice list with line counts and the number of Gemini calls it will take, and **wait for my OK** before running anything. Each slice consumes AI Pro quota.

## 3. Audit each slice with Gemini

For each slice, write `.agy/audit/<slice>.prompt.md`:

```
Audit the code in <paths> of this repository against the rubric in .agy/rubric.md (use its Rules section).
Read .agy/audit/inventory.md first for context. Read other parts of the repo when needed to judge a finding, but only report findings located in <paths>.

Rules:
- Report patterns, not every instance: for a repeated problem, give one finding with the count and up to 3 path:line examples.
- Each finding: rubric id (e.g. R3, RT1, A2), severity (critical / major / minor), path:line evidence, what is wrong, the concrete fix in the style the rubric prefers, and estimated size (S: under 1 hour, M: half a day, L: more).
- Recommend adding an abstraction only when you can name the concrete problem it removes.
- When the rubric's primary lens and SOLID conflict, list it under "Tensions", not as a finding.
- Maximum 15 findings, most severe first. Then a "Strengths" section with up to 3 things this slice does well that should be kept.
```

Run slices one at a time: `agy-ask -o .agy/audit/<slice>.md -f .agy/audit/<slice>.prompt.md`

- Exit 3: the repo changed. Stop everything and tell me.
- Exit 2 with the PTY hint: retry once with `AGY_ASK_PTY=1`.
- Quota or rate-limit error: stop, report which slices are done, and tell me to resume later with `/gemini-audit <remaining slice>`.

## 4. Verify

For every critical and major finding, open the cited code and classify it ACCEPTED, REJECTED (one-line reason) or NEEDS PAUL. For minor findings, verify a sample of at least a third; mark the rest UNVERIFIED. Reject anything whose evidence does not match the code. Findings the rubric flags as policy or product risks (e.g. B1 in Python) are always NEEDS PAUL.

## 5. Consolidate into a backlog

Write `plans/audit-<yyyy-mm-dd>.md` (merge into it if it exists from an earlier slice run today):

1. **Summary**: stack, 5 lines on the overall state, plus a table with one row per rubric id: status (ok / some issues / problem) and one-line note.
2. **Decisions for Paul**: every NEEDS PAUL item and every Tension, as direct questions.
3. **Backlog**: ACCEPTED findings grouped into batches. Each batch is one reviewable change (one branch, one `/gemini-review`), touching one area. Order: security, data-loss and realtime/crash risks first, then things that block other refactors, then the rest. For each batch: goal, findings included (with rubric ids), files, size, and whether it needs characterization tests (or, for projects without tests, a manual smoke-test checklist) before touching the code.
4. **Strengths to keep**.
5. **Rejected and unverified**: short list with reasons, so I can calibrate.

## 6. Report and stop

Reply in English: the summary, the decisions I need to make, and the first 3 batches. Do not start fixing anything.
