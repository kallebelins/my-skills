---
name: spec-kit-1-specify
description: "Spec-kit sub-skill 1 — writes spec.md only (business rules, contracts, data models, edge cases, error handling, measurable acceptance criteria). Runs first in the spec-kit sequence, after the orchestrator resolved folder, architecture reference and business context. WHEN: called by the spec-kit orchestrator in Step 4.1. DO NOT USE FOR: standalone use without the orchestrator, writing plan.md/tasks.md, implementation."
argument-hint: "Called by spec-kit with: feature folder, architecture_ref, business context"
---

# Spec-Kit Sub-Skill 1 — spec.md

## Purpose

Write `spec.md`, the single source of truth for scope. It consolidates every business rule from the sources and defines measurable acceptance criteria that `plan.md` and `tasks.md` depend on.

## When to Use

- The `spec-kit` orchestrator reaches Step 4.1.

## When Not to Use

- Called directly by the user without the orchestrator → hand off to `spec-kit`.

## Inputs

| Input | Required | Source | If missing |
|---|---|---|---|
| Feature folder `docs/specs/feature-{NNN}/` | Yes | `spec-kit` Step 1 | Stop; return to `spec-kit`. |
| `architecture_ref` | Yes | `spec-kit` Step 2 | Stop; return to `spec-kit`. |
| Business context (conversation + context files read) | Yes | `spec-kit` Step 3 | Stop; return to `spec-kit`. |

## Preconditions

- [ ] All inputs above are available.

## Procedure

1. Copy the structure and frontmatter of [spec.template.md](../spec-kit/templates/spec.template.md).
2. Fill **Sources** with the conversation reference and every context file path read.
3. Fill **Scope Summary** with short, plannable capability-group names (each becomes a phase name).
4. Fill **Out of Scope** with explicit exclusions from the sources.
5. Fill **Business Rules**: one rule per bullet, numbered `BR-XX`, grouped by topic. Do not merge distinct rules. Do not drop details.
6. If the feature has APIs, components or integrations → fill **Contracts**. Otherwise → delete the section.
7. If the feature persists or transfers data → fill **Data Models**. Otherwise → delete the section.
8. Derive **Edge Cases** from the rules (boundaries, invalid input, concurrency, empty states, permissions).
9. Fill **Error Handling**: how each failure surfaces to the user/caller.
10. Write **Acceptance Criteria** numbered `AC-XX`; each must be measurable and verifiable on its own.
11. If any gap blocks a measurable criterion → list it in **Open Questions** and ask the user. Update the spec with the answers. Delete the section when empty.
12. Run Done Criteria; then hand back to `spec-kit`.

## Rules

### MUST

- Trace every rule to a source listed in **Sources**.
- Use measurable criteria (numbers, states, observable results).
- Write all content in English; keep code identifiers, paths and frontmatter keys unchanged.

### MUST NOT

- Fabricate rules, contracts, fields or integrations.
- Write vague criteria (e.g. "must work correctly").
- Write any file other than `docs/specs/feature-{NNN}/spec.md`.

## Handoff

| Direction | Skill | Data |
|---|---|---|
| Called by | [spec-kit](../spec-kit/SKILL.md) Step 4.1 | Folder, `architecture_ref`, context |
| Next | [spec-kit-2-plan](../spec-kit-2-plan/SKILL.md) (via `spec-kit`) | `spec.md` |

## Output

`docs/specs/feature-{NNN}/spec.md`. Output language: English.

## Done Criteria

- [ ] Frontmatter matches the template (`doc`, `feature`, `status`, `architecture_ref`, `generated_by`).
- [ ] No `{{placeholder}}` remains.
- [ ] **Scope Summary** exists; every item is a short, plannable name.
- [ ] Every business rule traces to a listed source.
- [ ] **Contracts**/**Data Models** present only when applicable.
- [ ] Every acceptance criterion is individually measurable and numbered `AC-XX`.
- [ ] **Open Questions** is empty or removed.
- [ ] All content is in English.

_Original author: Kallebe Lins | gh:kallebelins/my-skills_
