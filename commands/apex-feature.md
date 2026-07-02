---
description: Start a feature with APEX — analyze complexity, plan, then build test-first.
argument-hint: <feature description>
---

The user wants to build: **$ARGUMENTS**

Follow the APEX Enhanced workflow:

1. **Classify complexity** (Lightweight / Standard / Robust) and state your reasoning in one line.
2. **Ask only the clarifying questions that change the design** — 2-3 for Lightweight, more for Robust. Skip questions you can answer from the code below.
3. For **Standard/Robust**, enter **plan mode** and present a plan (goal, success criteria, task breakdown, risks) for approval before editing. For **Lightweight**, propose a short task list and proceed.
4. Once approved, work **test-first**: write failing tests, then implement to green. The quality-gate hook runs automatically after edits — fix any failures before moving on.

## Repo context
Current branch and status:
!`git status --short --branch 2>/dev/null || echo "(not a git repo)"`

Project manifest (for stack/test-runner detection):
!`for f in package.json pyproject.toml Cargo.toml go.mod pom.xml; do [ -f "$f" ] && echo "== $f ==" && head -30 "$f"; done 2>/dev/null || echo "(no recognized manifest)"`
