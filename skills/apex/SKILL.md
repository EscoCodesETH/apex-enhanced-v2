---
name: apex
description: >-
  Run the full APEX feature-development procedure for a non-trivial feature, bug fix,
  or refactor — classify complexity, plan, build test-first, review, ship. Invoke when
  the user says "use APEX" / "APEX Enhanced" or wants a disciplined plan-then-build flow.
  (Standing principles are always-on in CLAUDE.md; this skill is the step-by-step ceremony.)
---

# APEX feature procedure

The always-on rules (TDD-first, scale-to-risk, no fabricated progress, commit/branch
protocol) live in CLAUDE.md and already apply. This skill is the **on-demand procedure**
to run a piece of work end to end.

> **Building an *existing* project? Use the steps below.** Starting a *new* project, or
> planning before a hackathon build window (research, architecture, spikes, API/cloud
> experiments, wireframes)? Run **`/apex-discovery`** first to produce a `BLUEPRINT.md`,
> then come back here per backlog item.

## Steps

1. **Classify complexity** and say which mode + why, in one line:
   - **Lightweight** — UI/copy/prototype: short task list, smoke test, ship.
   - **Standard** — logic/API/component: plan → tests-first → implement → review.
   - **Robust** — payments/auth/migration/security: plan + threat model + extensive tests + rollback note.

2. **Clarify only what changes the design.** 2-3 questions for Lightweight; more for Robust. Skip anything you can read from the code.

3. **Plan (Standard/Robust).** Enter plan mode; present goal, success criteria, task breakdown, and risks for approval before large edits. For Lightweight, propose a short task list and go.

4. **Build test-first.** Write failing tests, then implement to green. The quality-gate hook runs after edits — fix any block before moving on. Track steps with the task tools (never fabricated progress bars).

5. **Review.** Run `/apex-review` (delegates to the `apex-reviewer` subagent) for craft/design; use built-in `/code-review` for an adversarial bug pass on risky changes.

6. **Ship.** Run `/apex-commit` for atomic conventional commits + PR description into `staging`, or `/apex-ship` to also push, open the PR, and run Greploop until the Greptile score hits 5/5.

## Companion commands
- `/apex-discovery <idea>` — **before** building: validate, architect, spike, produce `BLUEPRINT.md`
- `/apex-feature <description>` — entry point for steps 1-4
- `/apex-review [target]` — step 5
- `/apex-commit` — step 6 (commits + PR description only)
- `/apex-ship [title]` — step 6 extended: verify → commit → push → PR into `staging` → Greploop to 5/5
