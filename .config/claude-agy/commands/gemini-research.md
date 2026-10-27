---
description: Ask Gemini (agy) to research something on the live web (gem/library/API status, breaking changes, docs) before Claude implements with stale knowledge.
argument-hint: <question>
allowed-tools: Bash(agy-ask:*), Bash(mkdir:*), Read, Write, Grep, Glob
---

Question: $ARGUMENTS

If the question is empty, stop and ask me what to research.

## 1. Build the prompt

Pick a short kebab-case slug for the question. Write `.agy/research-<slug>.prompt.md`:

```
Research this on the live web: <question>

Context: check the versions actually used in this repository (Gemfile.lock, package.json and its lockfile, pyproject.toml / uv.lock / requirements.txt, CMakeLists.txt or .jucer for the JUCE version, addons.make and the openFrameworks version, .ruby-version, .tool-versions, or equivalents) and answer for those versions.

Deliver:
1. Direct answer in 3 to 5 lines.
2. What is current as of today: latest versions, deprecations, breaking changes relevant to the versions this repo uses.
3. Concrete implications for this repo (what would need to change, if anything), with path:line when it touches existing code.
4. Sources: a list of URLs with publication or last-updated dates. Prefer official docs, changelogs and release notes over blog posts.

Mark anything you could not confirm with a source as "unverified". Do not guess version numbers.
```

## 2. Run Gemini

Run: `agy-ask -o .agy/research-<slug>.md -f .agy/research-<slug>.prompt.md`

Handle exit codes as usual: 3 means stop and tell me; 2 with the PTY hint means retry once with `AGY_ASK_PTY=1`.

## 3. Report

Read the answer. Reply in English with: the direct answer, whether it changes any current plan or code (say which), and the sources list. If the sources are weak or missing, say so plainly instead of repeating the claim.
