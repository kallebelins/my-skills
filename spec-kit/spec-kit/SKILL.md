---
name: spec-kit
created by: Kallebe Lins | gh:kallebelins/my-skills
description: "Use when planning a feature for this repository. Triggers on: plan a feature, generate a spec-kit, /spec command, specify and plan work before coding. Orchestrates 4 sub-skills to produce spec.md, plan.md and tasks.md under docs/specs/feature-{NNN}/, and register the feature in docs/backlog.md, in that strict order. Stack-agnostic — never assumes angular/dotnet/quarkus."
argument-hint: "Feature name/description (free text) and, optionally, a path to a context file with business rules"
---

# Spec-Kit Generation (Orchestrator)

## Purpose

Turn a feature request into a complete, self-contained spec-kit — `spec.md`, `plan.md`, `tasks.md` — before any code is written. This skill does not write file content itself: it resolves the feature folder and architecture reference, gathers business context, and then delegates each file to a dedicated sub-skill, in an order where each file only depends on files already written.

This skill is **stack-agnostic**. It must never hardcode `angular`, `dotnet`, or `quarkus` — the architecture reference is always resolved at runtime (Step 2).

## When to Use

- Someone asks to plan, specify, or spec out a feature before implementing it
- A `/spec` command is triggered
- You need to capture business rules and break them into phases/tasks before coding begins

## Output Files (generation order — do not reorder)

All files MUST be created under `docs/specs/feature-{NNN}/` (see Step 1 for `{NNN}`):

| # | File | Written by | Content |
|---|------|-----------|---------|
| 1 | `spec.md` | [`spec-kit-spec`](../spec-kit-spec/SKILL.md) | Complete specification: business rules, contracts/data models (when applicable), edge cases, error handling, measurable acceptance criteria |
| 2 | `plan.md` | [`spec-kit-plan`](../spec-kit-plan/SKILL.md) | Ordered phases, each with a `[ ]` checkbox, derived 1:1 from `spec.md`'s Scope Summary |
| 3 | `tasks.md` | [`spec-kit-tasks`](../spec-kit-tasks/SKILL.md) | Tasks grouped by phase, each with architecture/implementation detail inline and its own `[ ]` checkbox |

**Why this order:** `spec.md` defines what will be built — it must exist before `plan.md` can sequence it into phases and before `tasks.md` can break it into concrete actions.

After these 3 files exist, a 4th sub-skill registers the feature at project level:

| # | File | Written by | Content |
|---|------|-----------|---------|
| 4 | `docs/backlog.md` | [`spec-kit-backlog`](../spec-kit-backlog/SKILL.md) | One `[ ]` entry for this feature, added to the project's macro-level feature list (outside `docs/specs/feature-{NNN}/`) |

## Procedure

### Step 1 — Resolve the Feature Folder

1. List existing folders under `docs/specs/` matching `feature-{NNN}` (3-digit zero-padded, e.g. `feature-001`, `feature-002`).
2. Take the highest `NNN` found and use `NNN + 1` as the new feature number. If `docs/specs/` doesn't exist or has no `feature-*` folders, start at `feature-001`.
3. Create `docs/specs/feature-{NNN}/`. This is the only folder this skill and its sub-skills may write to for this run.
4. The human-readable feature name/description (given by the user) is used inside the file contents (titles, headings) — it is **not** part of the folder name.

### Step 2 — Resolve the Architecture Reference

1. Check whether `docs/architecture.md` exists at the repo root.
2. If it exists: read it and use it as the single source of truth for architecture/implementation conventions in Steps 4-5 below.
3. If it does **not** exist:
   a. Suggest running [`spec-kit-architecture`](../spec-kit-architecture/SKILL.md) to generate `docs/architecture.md` (brownfield discovery or greenfield definition) before planning features — this is the recommended path for a durable architecture reference with governance principles and development guidelines.
   b. If the user declines or needs a one-off spec now, fall back to asking which architecture/pattern to follow for this feature (e.g. point to an existing `docs/{stack}/` guide such as `docs/dotnet/`, `docs/angular/`, `docs/quarkus/`, or describe the pattern directly). Do not guess or default to a specific stack.
4. Record the resolved reference (file path or the user's description) — it will be quoted in `tasks.md` by `spec-kit-tasks`.

### Step 3 — Gather Business Context

1. Use the feature description already given by the user in the conversation as the primary source.
2. If the user points to a context file (e.g. a requirements doc), read it with `read_file` and treat it as an additional source, on equal footing with the conversation text.
3. If business rules, criteria, or scope are incomplete or ambiguous for a spec this complete, ask the user targeted clarifying questions rather than inventing rules. Do not proceed to Step 4 with unresolved gaps that block writing measurable acceptance criteria.

### Step 4 — Generate the Spec Files, in Strict Order

Follow each sub-skill below **in this exact order**. Each one declares its own preconditions and self-check — do not skip a sub-skill's checklist and do not start sub-skill N+1 before sub-skill N's output file exists and passes its self-check.

1. [`spec-kit-spec/SKILL.md`](../spec-kit-spec/SKILL.md) → `spec.md`
2. [`spec-kit-plan/SKILL.md`](../spec-kit-plan/SKILL.md) → `plan.md`
3. [`spec-kit-tasks/SKILL.md`](../spec-kit-tasks/SKILL.md) → `tasks.md`

### Step 5 — Self-Verification Before Handing Back

- [ ] All 3 files exist under `docs/specs/feature-{NNN}/`
- [ ] Every file's frontmatter matches its template in `spec-kit/templates/`
- [ ] No `{{placeholder}}` remaining in any file
- [ ] No files outside `docs/specs/feature-{NNN}/` were created or modified, except `docs/backlog.md` (Step 6)
- [ ] No files from other `feature-*/` folders were touched
- [ ] `plan.md` phases map 1:1 to `spec.md`'s Scope Summary; `tasks.md` phases map 1:1 to `plan.md` phases
- [ ] Every task in `tasks.md` references the architecture source resolved in Step 2

### Step 6 — Register the Feature in the Backlog

Always run this step after Step 5 passes — this is not optional, every spec written must be reflected in the backlog:

1. Invoke [`spec-kit-backlog/SKILL.md`](../spec-kit-backlog/SKILL.md) in **Mode A — Register existing spec**, passing the path to the `spec.md` just written.
2. `spec-kit-backlog` creates or updates `docs/backlog.md` at the project's `docs/` root (not inside `docs/specs/feature-{NNN}/`) with a `[ ]` entry for this feature.
3. Confirm the entry was added (or already existed, idempotently) before reporting back to the user.

Report back to the user with the feature folder path, a short summary of the phases created, and confirmation that the feature was added to `docs/backlog.md`.
