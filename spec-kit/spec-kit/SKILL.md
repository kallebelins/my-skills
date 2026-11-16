---
name: spec-kit
description: "Orchestrates feature planning before any code is written: resolves the feature folder and architecture reference, gathers business context, then hands off to spec-kit-1-specify, spec-kit-2-plan, spec-kit-3-tasks and spec-kit-4-backlog in strict order to produce spec.md, plan.md, tasks.md under docs/specs/feature-{NNN}/ and register the feature in docs/backlog.md. Stack-agnostic. WHEN: plan a feature, specify a feature, /spec, generate a spec-kit, break a feature into phases and tasks before coding. DO NOT USE FOR: implementing tasks (use spec-kit-executor), writing application code."
argument-hint: "Feature name/description (free text) and, optionally, the path to a context file with business rules"
---

# Spec-Kit (Orchestrator)

## Purpose

Turn a feature request into a complete spec-kit — `spec.md`, `plan.md`, `tasks.md` — and a backlog entry, before any code is written. This skill does not write file content itself: it resolves shared context and hands off each file to a dedicated sub-skill, in an order where each file only depends on files already written.

## When to Use

- The user asks to plan, specify or spec out a feature before implementing it.
- The `/spec` command is triggered.
- Business rules must be captured and broken into phases/tasks before coding.

## When Not to Use

- Implementing or marking a task as done → hand off to `spec-kit-executor`.
- Only maintaining the backlog (brainstorming/discovery) → hand off to `spec-kit-4-backlog`.
- Any request that requires writing application code.

## Inputs

| Input | Required | Source | If missing |
|---|---|---|---|
| Feature name/description | Yes | Conversation | Ask the user. |
| Context file (requirements, refinement) | No | Path given by the user | Proceed with the conversation only. |
| Architecture reference | Yes | `docs/*architecture*.md` | Hand off to `spec-kit-0-architecture` (Step 2). |

## Preconditions

- [ ] The request is planning, not execution.
- [ ] The repository root is known (folder that contains `docs/` or where `docs/` will be created).

## Procedure

### Step 1 — Resolve the feature folder

1. List folders under `docs/specs/` matching `feature-{NNN}` (3 digits, zero-padded).
2. If none exist (or `docs/specs/` does not exist) → use `feature-001`. Otherwise → use highest `NNN` + 1. Ignore suffixes (e.g. `feature-082-gs` counts as `082`).
3. Create `docs/specs/feature-{NNN}/`. This is the only folder the sub-skills 1–3 may write to in this run.
4. Use the human-readable feature name only inside file contents, never in the folder name.

### Step 2 — Resolve the architecture reference

1. Search `docs/` for files matching `*architecture*.md`.
2. If exactly one applies to the feature's module/stack → read it and record its path as `architecture_ref`.
3. If several exist → ask the user which applies (feature may span several; record all that apply).
4. If none exists → hand off to `spec-kit-0-architecture`. Resume at Step 3 only after it returns a written document path.
5. If the user refuses to create one → ask the user to describe the pattern; record `agreed with the user: <short description>`.

### Step 3 — Gather business context

1. Use the feature description in the conversation as the primary source.
2. If the user gave a context file → read it in full; treat it as equal to the conversation.
3. If rules, scope or criteria are ambiguous enough to block measurable acceptance criteria → ask targeted questions. Do not continue to Step 4 with blocking gaps.

### Step 4 — Generate the files, in strict order

Hand off in this exact order. Do not start sub-skill N+1 until sub-skill N's file exists and passes its own Done Criteria.

1. `spec-kit-1-specify` → `spec.md`
2. `spec-kit-2-plan` → `plan.md`
3. `spec-kit-3-tasks` → `tasks.md`

### Step 5 — Cross-file verification

Run the Done Criteria checks 1–7 below. If any fails → fix the responsible file via its sub-skill, then re-check.

### Step 6 — Register in the backlog (mandatory)

1. Hand off to `spec-kit-4-backlog` in **Mode A — Register existing spec**, passing the `spec.md` path.
2. Confirm the entry exists in `docs/backlog.md` (added or already present).

### Step 7 — Report

Report: feature folder path, list of phases, and confirmation of the backlog entry.

## Rules

### MUST

- Follow the order spec → plan → tasks → backlog.
- Use the templates in [templates/](templates/) for every file.
- Write every generated file and every message to the user in English, including headings, field labels and identifiers (`BR-XX`, `AC-XX`). Keep YAML frontmatter keys, file names and code identifiers unchanged.
- Ask instead of guessing whenever business rules or architecture are unknown.

### MUST NOT

- Write application code or run implementation tasks.
- Hardcode a stack (Angular, .NET, Spring, Quarkus, etc.); the stack comes from `architecture_ref`.
- Create or modify files outside `docs/specs/feature-{NNN}/`, except `docs/backlog.md` (Step 6) and the architecture document (Step 2, via `spec-kit-0-architecture`).
- Touch other `feature-*` folders.
- Invent business rules, contracts, paths or conventions not present in the sources.

## Resources

| File | When to read |
|---|---|
| [templates/spec.template.md](templates/spec.template.md) | Used by `spec-kit-1-specify` |
| [templates/plan.template.md](templates/plan.template.md) | Used by `spec-kit-2-plan` |
| [templates/tasks.template.md](templates/tasks.template.md) | Used by `spec-kit-3-tasks` |
| [templates/backlog.template.md](templates/backlog.template.md) | Used by `spec-kit-4-backlog` |

## Handoff

| Order | Skill | Receives | Returns |
|---|---|---|---|
| 0 (conditional) | [spec-kit-0-architecture](../spec-kit-0-architecture/SKILL.md) | Module/stack to document | Path of `docs/<module>-architecture.md` |
| 1 | [spec-kit-1-specify](../spec-kit-1-specify/SKILL.md) | Feature folder, `architecture_ref`, business context | `spec.md` |
| 2 | [spec-kit-2-plan](../spec-kit-2-plan/SKILL.md) | `spec.md` | `plan.md` |
| 3 | [spec-kit-3-tasks](../spec-kit-3-tasks/SKILL.md) | `spec.md`, `plan.md`, `architecture_ref` | `tasks.md` |
| 4 | [spec-kit-4-backlog](../spec-kit-4-backlog/SKILL.md) | `spec.md` path (Mode A) | Backlog entry |
| After planning | [spec-kit-executor](../spec-kit-executor/SKILL.md) | A task from `tasks.md` | Implemented task |

## Output

- `docs/specs/feature-{NNN}/spec.md`, `plan.md`, `tasks.md`.
- One entry in `docs/backlog.md`.
- Output language: English.

## Done Criteria

- [ ] 1. All 3 files exist under `docs/specs/feature-{NNN}/`.
- [ ] 2. Every file's frontmatter matches its template.
- [ ] 3. No `{{placeholder}}` remains.
- [ ] 4. `plan.md` phases map 1:1 to `spec.md` **Scope Summary**; `tasks.md` phases map 1:1 to `plan.md`.
- [ ] 5. Every task in `tasks.md` is grounded in `architecture_ref`.
- [ ] 6. No file outside the allowed set was created or modified.
- [ ] 7. No other `feature-*` folder was touched.
- [ ] 8. Backlog entry confirmed.
- [ ] 9. All generated content is in English.

_Original author: Kallebe Lins | gh:kallebelins/my-skills_
