---
description: Have Gemini (agy) read heavy material (PDFs, screenshots, videos, long docs, whole folders) and write a faithful markdown digest, so Claude works from the digest without filling its context.
argument-hint: <file-or-folder> [what to extract]
allowed-tools: Bash(agy-ask:*), Bash(mkdir:*), Bash(ls:*), Bash(dirname:*), Bash(basename:*), Read, Write, Glob
---

Input: $ARGUMENTS

The first argument is the file or folder. Anything after it describes what to extract. If nothing is given, stop and ask.

## 1. Build the prompt

Name the digest after the input: `.agy/digest-<name>.md`. Write `.agy/digest-<name>.prompt.md`:

```
Read <path> completely (every page, image, frame or file inside it).

Goal: <what to extract, or if not specified: requirements, decisions, numbers, names, dates and open questions relevant to building software from this material>.

Write a faithful digest in markdown:
- Keep exact figures, names, dates, prices and quoted wording exactly as they appear. Do not round or paraphrase numbers.
- Organize by topic, not by page order, but cite the source location for each point (file, page, timestamp or image name).
- Separate clearly what the material states from anything you infer. Label inferences as "inference".
- List anything unreadable, cut off or ambiguous under "Unclear".
```

## 2. Run Gemini

If the input is outside this repository, pass its folder with `-d <folder>` so agy can read it.

Run: `agy-ask -o .agy/digest-<name>.md [-d <folder>] -f .agy/digest-<name>.prompt.md`

Handle exit codes as usual: 3 means stop and tell me; 2 with the PTY hint means retry once with `AGY_ASK_PTY=1`.

## 3. Report

Read only the digest, not the original material. Reply in English with a 5-line summary, the "Unclear" items, and the digest path. From now on in this session, use the digest as the source for this material.
