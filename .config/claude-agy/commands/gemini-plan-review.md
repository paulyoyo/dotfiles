---
description: Independent read-only review of an implementation plan by Gemini (agy). Use for big or architectural changes.
argument-hint: <path/to/plan.md>
allowed-tools: Bash(agy-ask:*), Bash(agy-stack:*), Bash(mkdir:*), Bash(ls:*), Read, Write, Edit, Grep, Glob
---

Plan to review: $ARGUMENTS

If no path was given, use the most recently modified file in `plans/`. If there is none, stop and ask me for the plan. Do not write one on your own.

## 0. Stack and rubric

Run `agy-stack`. Exit 0: the rubric is at `.agy/rubric.md`. Exit 4: ask me which stack, then `agy-stack -s <stack>`. Exit 5: continue without a rubric (drop the rubric sentence from the prompt below).

## 1. Build the prompt

Write `.agy/plan-review.prompt.md` with exactly this content, replacing PLAN_PATH with the plan's repo-relative path:

```
Review the implementation plan at PLAN_PATH against the actual code in this repository. Judge design choices against the conventions in .agy/rubric.md and cite its rule ids when relevant.

Report only what matters, in these sections:
A. Wrong assumptions: places where the plan assumes something about the existing code that is not true. Give path:line evidence.
B. Missing pieces: edge cases, migrations, data backfills, authorization, error paths, tests the plan forgets.
C. Over-engineering: steps, abstractions, new classes/services/gems that the problem does not need. Propose the simpler alternative that fits the existing conventions of this codebase.
D. Ordering risks: steps that should happen in a different order, or that break the app if deployed halfway.

Rate each finding critical / major / minor. Maximum 12 findings, most severe first.
If the plan is sound, say "Plan is sound" and list at most 3 minor notes.
```

## 2. Run Gemini

Run: `agy-ask -o .agy/<plan-basename>.review.md -f .agy/plan-review.prompt.md`

- Exit 3: the repo changed during the review. Stop, tell me, touch nothing.
- Exit 2 with a hint about `AGY_ASK_PTY=1`: retry once with that env var set.
- Any other failure: show me the error and stop.

## 3. Verify every finding yourself

Read the review. For each finding, open the cited code and decide:

- **ACCEPTED**: it is real and relevant.
- **REJECTED**: false, vague, or not evidenced. One-line reason.
- **NEEDS PAUL**: it is a product or architecture decision, not a factual error.

Gemini is a reviewer, not an authority. A finding without evidence you can confirm is REJECTED.

## 4. Update the plan

Apply only ACCEPTED findings to the plan. Append a `## Review log` section listing each finding, its verdict and the reason.

## 5. Report and stop

Reply in English. Put NEEDS PAUL items first as direct questions, then a short list of what changed in the plan. Do not implement anything. Do not send the plan back to Gemini unless I ask.
