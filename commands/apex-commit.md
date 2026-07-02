---
description: Create atomic, conventional commits and a PR description from current changes.
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*), Read
---

Prepare APEX-style commits for the current changes.

1. **Verify tests pass first.** If a test command exists and hasn't just been run, run it. Do not commit over red.
2. **Group changes into atomic commits**, each with a single clear purpose. Propose the grouping to the user before committing.
3. Write **Conventional Commit** messages: `<type>(<scope>): <subject>` where type ∈ feat|fix|docs|style|refactor|test|chore|perf. Body explains *why*; footer links issues (`Closes #N`).
4. After committing, generate a **PR description** (Summary / Changes / Testing / Breaking changes / Closes).

## State
!`git status --short 2>/dev/null || echo "(not a git repo)"`

Recent commits (match the existing style):
!`git log --oneline -10 2>/dev/null`

Diff to be committed:
!`git diff --staged 2>/dev/null | head -300; git diff 2>/dev/null | head -300`
