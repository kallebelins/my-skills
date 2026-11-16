---
name: spec-kit-3-tasks
description: "Spec-kit sub-skill 3 — writes tasks.md only: one-action tasks grouped by phase (matching plan.md), each with inline architecture/implementation detail grounded in the architecture reference, input, output, test scenarios and measurable acceptance criteria. Runs last in the file sequence. WHEN: called by the spec-kit orchestrator in Step 4.3. DO NOT USE FOR: executing or marking tasks done (use spec-kit-executor), writing spec.md/plan.md."
argument-hint: "Called by spec-kit with: spec.md, plan.md and architecture_ref"
---

# Spec-Kit Sub-Skill 3 — tasks.md

## Purpose

Write `tasks.md`: the granular, one-action-per-task breakdown organized by phase. Each task carries its own architecture/implementation detail, so no separate implementation document is needed. `tasks.md` is also the live progress record updated by `spec-kit-executor`.

## When to Use

- The `spec-kit` orchestrator reaches Step 4.3.

## When Not to Use

- Implementing, completing or commenting a task → hand off to `spec-kit-executor`.

## Inputs

| Input | Required | Source | If missing |
|---|---|---|---|
| `spec.md` | Yes | `spec-kit-1-specify` | Stop; return to `spec-kit`. |
| `plan.md` | Yes | `spec-kit-2-plan` | Stop; return to `spec-kit`. |
| `architecture_ref` | Yes | `spec.md` frontmatter | Stop; return to `spec-kit`. |

## Preconditions

- [ ] `plan.md` exists with ordered phases.
- [ ] `spec.md` exists with business rules and numbered acceptance criteria.
- [ ] The architecture document in `architecture_ref` was read in this session (or the agreed pattern is known).

## Procedure

1. Copy the structure and frontmatter of [tasks.template.md](../spec-kit/templates/tasks.template.md).
2. For each phase in `plan.md`, in order, add a heading `## Phase X — <identical name>`.
3. Break each phase into tasks, each with exactly one action (one file, one endpoint, one component, one migration...).
4. Order tasks inside a phase so dependencies come first (e.g. model → repository → service → controller → UI).
5. Number tasks `X.Y` (X = phase number, Y = sequence starting at 1).
6. Fill every field using the format below.
7. Run Done Criteria; then hand back to `spec-kit`.

### Mandatory task format

```
- [ ] X.Y - Task name
Description: <one action>
Architecture/Implementation: <layer, pattern, convention, commands — taken from architecture_ref>
Input: <spec.md#section reference>
Output: <exact path of the file/artifact to create or change>
Test scenarios: <from the Edge Cases / Error Handling of spec.md>
Acceptance criteria: <measurable; cite AC-XX from spec.md>
```

| Field | Rule |
|---|---|
| Description | One clear action. Never bundle unrelated actions. |
| Architecture/Implementation | Mandatory, never empty. Only conventions present in `architecture_ref`. If the reference does not cover the case → ask the user; do not invent. |
| Input | Link to the `spec.md` section implemented. Omit only if none. |
| Output | Exact path. If the path cannot be derived from `architecture_ref` or the code → ask. |
| Test scenarios | From `spec.md` **Edge Cases**/**Error Handling**. Omit only if none apply. |
| Acceptance criteria | Measurable and traceable to a `spec.md` `AC-XX`. |

## Rules

### MUST

- Keep phase headings identical to `plan.md`.
- Ground every **Architecture/Implementation** field in `architecture_ref`.
- Write all content and field labels in English; keep code identifiers and paths unchanged.

### MUST NOT

- Invent conventions, paths, libraries or commands not found in `architecture_ref` or the code.
- Create tasks with more than one action.
- Write any file other than `docs/specs/feature-{NNN}/tasks.md`.

## Handoff

| Direction | Skill | Data |
|---|---|---|
| Called by | [spec-kit](../spec-kit/SKILL.md) Step 4.3 | `spec.md`, `plan.md`, `architecture_ref` |
| Returns to | [spec-kit](../spec-kit/SKILL.md) Step 5 | `tasks.md` |
| Executed later by | [spec-kit-executor](../spec-kit-executor/SKILL.md) | One task at a time |

## Output

`docs/specs/feature-{NNN}/tasks.md`. Output language: English.

## Done Criteria

- [ ] Frontmatter matches the template.
- [ ] Phase headings match `plan.md` 1:1, same order.
- [ ] Every task has Description, Architecture/Implementation, Input, Output, Acceptance criteria (Test scenarios only omitted when none apply).
- [ ] Numbering is `X.Y` with X = phase number.
- [ ] Every acceptance criterion cites a `spec.md` `AC-XX`.
- [ ] No task bundles more than one action.
- [ ] All content is in English.

_Original author: Kallebe Lins | gh:kallebelins/my-skills_
