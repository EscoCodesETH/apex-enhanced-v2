---
description: Ship a feature — verify, commit, push, open a PR into staging, then run Greploop until 5/5.
argument-hint: "[optional: PR title]"
allowed-tools: Bash(git status:*), Bash(git branch:*), Bash(git log:*), Bash(git diff:*), Bash(git push:*), Bash(gh pr create:*), Bash(gh pr view:*), Bash(gh pr list:*), Read, Task, SlashCommand
---

Ship the current feature branch end to end. This chains APEX's local loop into the
Greptile PR loop. Follow the standing rules in CLAUDE.md (Conventional Commits, `staging`
as integration branch, small focused PRs).

## Do this in order

1. **Preflight — refuse to ship on red or from the wrong branch.**
   - If the current branch is `staging` or `main`, stop and tell the user to move work onto a feature branch.
   - Run the full test suite (detect it from the manifest). If tests fail, **stop** and report — do not push.

2. **Commit** any uncommitted work using the `/apex-commit` conventions (atomic, Conventional Commits). If the tree is already clean, skip.

3. **Push** the feature branch: `git push -u origin <branch>`. State what you're about to push before running it.

4. **Open or reuse a PR into `staging`** (fall back to `main` if `staging` doesn't exist):
   - If a PR from this branch already exists, reuse it.
   - Otherwise `gh pr create --base <base> --head <branch>` with a title (`${ARGUMENTS:-derive from the commits}`) and an APEX PR body (Summary / Changes / Testing / Breaking / Closes).
   - Capture the PR number.

5. **Run Greploop** on that PR number to iterate Greptile review → fix → push until 5/5:
   - Invoke the **greploop** skill with the PR number (e.g. it reads the Greptile review, applies fixes, re-pushes, and re-reviews until 5/5 or its iteration cap).
   - If the greploop skill is **not installed** (see preflight below), tell the user how to add it and instead do one manual pass: read Greptile's review on the PR, apply fixes, push, and report the new score. Do not fake a loop.

6. **Report** the PR URL and the final Greptile score.

## Preflight context
Branch & tree:
!`git rev-parse --abbrev-ref HEAD 2>/dev/null; git status --short 2>/dev/null || echo "(not a git repo)"`

Does `staging` exist? Existing PR for this branch?
!`git show-ref --verify --quiet refs/heads/staging && echo "staging: yes" || echo "staging: no (will base on main)"; gh pr list --head "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)" --json number,url,baseRefName 2>/dev/null || echo "(gh not available or not authed)"`

Is Greploop installed?
!`ls ~/.claude/skills/greploop/SKILL.md .claude/skills/greploop/SKILL.md 2>/dev/null || echo "greploop skill NOT found — install: npx skillkit install greptileai/skills"`

Test runner hint:
!`for f in package.json pyproject.toml Cargo.toml go.mod; do [ -f "$f" ] && echo "found $f"; done 2>/dev/null || echo "(no manifest)"`
