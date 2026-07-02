# APEX — always-on engineering principles

<!--
  This is the ALWAYS-ON tier. Copy/merge it into your project root as CLAUDE.md
  (or ~/.claude/CLAUDE.md for global). Keep it lean — every line here costs context
  on every turn. Occasional procedures live in the `apex` skill (need-to-know).
  Enforcement lives in the quality-gate hook (deterministic, zero context cost).
-->

## How we work
- **Discovery before building.** For a new project (or pre-hackathon planning), run `/apex-discovery` first — validate, architect, and de-risk with spikes into a `BLUEPRINT.md` before writing production code.
- **Spikes are throwaway.** Experiments under `spikes/` or `experiments/` are exempt from TDD and the quality gate — prototype freely there; never ship from them.
- **Scale rigor to risk.** UI tweak → move fast. Business logic → plan + tests. Payments/auth/migrations → plan, threat-model, extensive tests, rollback note.
- **Tests first** for anything non-trivial. Tests must be able to fail; test behavior, not implementation. Coverage is a floor, not the goal.
- **A quality-gate hook runs lint/type-check after edits.** If it blocks, fix before continuing — do not work past red.
- **Never fabricate progress.** No invented percentages, scores, or time estimates. Report real tool output; track work with the task tools.
- **AI proposes, human decides.** For Standard/Robust work, plan and get approval before large edits (use plan mode).
- **Run the full test suite before considering work shippable.**

## Commits & branches
- **Conventional Commits**: `type(scope): subject` (feat|fix|docs|style|refactor|test|chore|perf). Body says *why*; footer links issues.
- Integration branch is **`staging`**. Branch features off latest `staging` (isolated worktree under `worktrees/` when parallelizing).
- Open **small, focused PRs** into `staging`, split by feature/behavioral boundary — not one large mixed diff. Keep them reviewable.
- After a feature PR merges to `staging`, rebase/update active feature branches before continuing.
- Promote `staging` → `main` only when the integrated set is release-ready.

## Reference, don't guess
- Vendored open-source dependencies live in `vendor-src/` (gitignored). For unfamiliar or fast-moving libraries, **search that source** for current APIs instead of relying on training data. Don't load whole repos into context — search.

## Deeper workflow
For the full feature/review/commit procedures, invoke the **`apex` skill** (or `/apex-feature`, `/apex-review`, `/apex-commit`). Those load on demand — this file stays lean.
