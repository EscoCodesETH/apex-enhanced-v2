---
description: Empathetic Sandi-Metz-style review of the current changes.
argument-hint: "[optional: path or PR to focus on]"
allowed-tools: Bash(git diff:*), Bash(git status:*), Read, Grep, Glob, Task
---

Perform an APEX-style code review. Focus: ${ARGUMENTS:-the current working diff}.

Delegate to the **apex-reviewer** subagent for the craft/design review, passing it
the diff below. If the changes look risky or bug-prone, also recommend `/code-review`
for an adversarial correctness pass.

## Changes under review
Staged:
!`git diff --staged --stat 2>/dev/null; git diff --staged 2>/dev/null | head -400`

Unstaged:
!`git diff --stat 2>/dev/null; git diff 2>/dev/null | head -400`
