# APEX Enhanced v2 (Claude Code plugin)

Same philosophy as v1 — adaptive complexity, TDD-first, quality gates, empathetic
review, smart commits — rebuilt on native Claude Code primitives, and organized by
**context-cost tier** so nothing wastes your context window.

## The three tiers (context engineering)

Every piece of guidance is placed by how it trades context cost against availability:

| Tier | Context cost | Reliability | APEX file |
|---|---|---|---|
| **Always-on** | High — injected every turn | Model *should* comply | [CLAUDE.md](CLAUDE.md) — standing principles + branch/PR protocol + reference-source policy |
| **On-demand (skill)** | ~Free until invoked | Model *chooses* to invoke | [skills/apex/SKILL.md](skills/apex/SKILL.md) — the feature/review/commit ceremony |
| **On-demand (subagent)** | ~Free until delegated | Model *chooses* to delegate | [agents/apex-reviewer.md](agents/apex-reviewer.md) — Sandi-Metz review |
| **Enforcement (hook)** | **Zero** | **Deterministic — always runs** | [hooks/quality-gate.sh](hooks/quality-gate.sh) — lint/type-check, blocks on red |

Keep `CLAUDE.md` lean: only put things that must be true *every turn*. Occasional
procedures belong in the skill; enforcement belongs in the hook (costs no context and
doesn't rely on the model remembering).

## What changed from v1

| v1 (prose you paste in) | v2 (native, tiered) |
|---|---|
| `apex.md` = one big always-loaded ruleset | Split: lean **CLAUDE.md** (always-on) + **skill** (on-demand ceremony) |
| Command files describing "when user says X…" | **Slash commands** with `$ARGUMENTS`, inline `` !`git diff` ``, `allowed-tools` |
| "Get approval before proceeding" prose | **Plan mode** (harness-native approval gate) |
| "Quality gates *automatic*" (model had to remember) | **Hook** — runs after every edit, **blocks on red** |
| Fabricated progress bars / "94/100" scores | Real task tracking + real tool output |
| `apex-review.md` prose | **Subagent** + built-in `/code-review` for bug hunts |
| Clone + copy script + stub npm package | **Plugin** ([.claude-plugin/plugin.json](.claude-plugin/plugin.json)) |

## Install

**Always-on layer** (per project): copy/merge [CLAUDE.md](CLAUDE.md) into your project root
(or `~/.claude/CLAUDE.md` for global). This is the only piece that must be placed manually —
plugins don't inject a CLAUDE.md for you.

**Everything else** — ship as a plugin, or copy into `.claude/`:
```bash
# CLAUDE.md (always-on) — copy or merge into project root
cp v2/CLAUDE.md ./CLAUDE.md

# On-demand pieces
mkdir -p .claude/skills .claude/commands .claude/agents
cp -r v2/skills/apex   .claude/skills/
cp    v2/commands/*.md  .claude/commands/
cp    v2/agents/*.md    .claude/agents/

# Enforcement hook — copy the script, then register it in .claude/settings.json.
cp v2/hooks/quality-gate.sh .claude/quality-gate.sh && chmod +x .claude/quality-gate.sh
```
> ⚠️ **Manual install path:** `hooks/hooks.json` uses `${CLAUDE_PLUGIN_ROOT}`, which only
> resolves when installed *as a plugin*. For a manual (copy-in) install, put this in
> `.claude/settings.json` and use `${CLAUDE_PROJECT_DIR}` (or an absolute path) instead:
> ```json
> {
>   "hooks": {
>     "PostToolUse": [
>       { "matcher": "Edit|Write|MultiEdit",
>         "hooks": [{ "type": "command",
>           "command": "${CLAUDE_PROJECT_DIR}/.claude/quality-gate.sh", "timeout": 60 }] }
>     ]
>   }
> }
> ```
For distribution, publish the repo to a plugin marketplace and `/plugin install apex-enhanced@<marketplace>` (the marketplace form bundles skill + commands + agent + hook automatically; you still place CLAUDE.md).

## Use
- `/apex-discovery a real-time collab whiteboard` — **before building**: validate, architect, spike (API/cloud experiments, wireframes) → `BLUEPRINT.md`. Ideal for new projects & pre-hackathon planning.
- `/apex-feature add rate limiting to the login endpoint` — classify, plan, build test-first
- `/apex-review` — empathetic Sandi-Metz review of the current diff
- `/apex-commit` — atomic conventional commits + PR description
- `/apex-ship [title]` — verify → commit → push → open PR into `staging` → run Greploop until 5/5
- Or just say "let's use APEX" — the skill triggers itself; the CLAUDE.md rules already apply.

### The full loop, chained
`/apex-ship` connects APEX's local inner loop to the Greptile PR loop:
`tests green → commit → push → PR into staging → Greploop (Greptile review → fix → re-review) until 5/5`.
It degrades gracefully: if the [greploop](https://github.com/greptileai/skills/tree/main/greploop)
skill isn't installed, it does one manual Greptile pass and tells you how to add the loop —
it will not fake iterations.

## Tuning the quality gate
[hooks/quality-gate.sh](hooks/quality-gate.sh) runs **fast** checks (lint / type-check) so it
can fire on every edit; the full test suite belongs at commit time (`/apex-commit`) or a
`Stop` hook. It no-ops safely when a tool or script is absent.
