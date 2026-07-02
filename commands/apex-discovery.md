---
description: Pre-build discovery for a new project or hackathon — validate the idea, design architecture, de-risk with spikes, and produce a build-ready blueprint. No production code.
argument-hint: <project / idea description>
---

The user wants to plan (not yet build): **$ARGUMENTS**

This is APEX **Discovery mode** — the 0→1 phase before the build clock starts. The goal is
to remove unknowns and produce a **blueprint** so that build day is pure execution.

## Rules for this phase
- **No production code.** Anything you run to learn is a *spike*: throwaway, kept under
  `spikes/` or `experiments/` (the quality gate skips those dirs — prototype freely).
- **Time-box experiments.** State the question a spike answers and stop once answered.
- **Decide, then record.** Every real choice becomes a line in the blueprint with its *why*.
- Don't scaffold the repo, install deps, or pick a final file layout until the blueprint is approved.

## Run these phases (adapt depth to the idea; skip what's irrelevant)

1. **Frame** — What are we building, for whom, and why now? Success criteria. Hard
   constraints (deadline/hackathon rules, required stack, budget, team size). List the
   biggest *unknowns* — these drive everything below.

2. **Validate** — Is this worth building? Prior art / competitors, feasibility, and scope
   for the time available (MVP vs. stretch). For anything needing current facts, use the
   `deep-research` skill rather than guessing.

3. **Architecture** — Propose 1-3 approaches with trade-offs; recommend one. Sketch the
   system (components + data flow, as a mermaid or ASCII diagram), the data model, and the
   key **decisions** (record each as a short ADR: choice · why · alternatives rejected).

4. **De-risk with spikes** — For each top unknown, run a *throwaway* experiment under
   `spikes/<name>/`:
   - **API tests** — hit the real endpoint, confirm auth/shape/limits/latency.
   - **Cloud experiments** — try the AWS/Azure/GCP service; confirm it does what you need.
   - **Tech spikes** — the one hard thing you're unsure you can build.
   Capture each finding in the blueprint (works / doesn't / gotchas). Delete the code or keep it clearly quarantined.

5. **Design the surface** — Wireframes (ASCII/mermaid), the primary user workflow(s), and
   **API contracts** (endpoints, request/response schemas, error cases). Enough that build
   day needs no re-litigation.

6. **Plan the build** — A prioritized backlog where each item is a future `/apex-feature`,
   sized and ordered by dependency. Identify the **critical path** and what's cut if time runs short.

## Deliverable — write `BLUEPRINT.md`
```markdown
# <Project> — Blueprint
## 1. Problem & goal            # who/what/why, success criteria
## 2. Constraints & deadline
## 3. Validation findings        # feasibility, prior art, scope call
## 4. Architecture               # diagram, data model, chosen approach
## 5. Decisions (ADRs)           # choice · why · rejected alternatives
## 6. Spike results              # each unknown → answer + gotchas
## 7. API contracts & wireframes
## 8. Build backlog              # ordered /apex-feature list + critical path
## 9. Open questions / risks
```

## Context (may be empty for a brand-new folder)
!`ls -la 2>/dev/null | head -30; echo "---"; git status --short 2>/dev/null || echo "(not a git repo yet — that's fine for discovery)"`

When the blueprint is approved, the build phase begins with `/apex-feature` per backlog item.
