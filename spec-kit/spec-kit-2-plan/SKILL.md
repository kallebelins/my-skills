---
name: spec-kit-2-plan
description: "Spec-kit sub-skill 2 — writes plan.md only: dependency-ordered phases derived 1:1 from spec.md "Scope Summary", each with a checkbox. Runs after spec-kit-1-specify and before spec-kit-3-tasks. WHEN: called by the spec-kit orchestrator in Step 4.2. DO NOT USE FOR: standalone use, writing spec.md/tasks.md, implementation."
argument-hint: "Called by spec-kit with: spec.md already written"
---

# Spec-Kit Sub-Skill 2 — plan.md

## Purpose

Write `plan.md`: the ordered phases that organize `spec.md` for execution. Phases are derived from `spec.md` **Scope Summary** — never invented. Each phase has its own checkbox for phase-level progress.

## When to Use

- The `spec-kit` orchestrator reaches Step 4.2.

## When Not to Use

- Called without an existing `spec.md` → hand off to `spec-kit`.

## Inputs

| Input | Required | Source | If missing |
|---|---|---|---|
| `spec.md` with non-empty **Scope Summary** | Yes | `spec-kit-1-specify` | Stop; return to `spec-kit`. |

## Preconditions

- [ ] `docs/specs/feature-{NNN}/spec.md` exists and has a non-empty **Scope Summary**.

## Procedure

1. Copy the structure and frontmatter of [plan.template.md](../spec-kit/templates/plan.template.md).
2. For each **Scope Summary** item, in order, create `- [ ] Phase N — <same name>`.
3. For each phase, fill **Depends on** (earlier phases only, or `none`).
4. For each phase, fill **Delivers** with the `spec.md` sections/contracts/models it covers.
5. If a phase depends on a later phase → reorder **Scope Summary** in `spec.md` and the phases together, keeping names identical.
6. Copy **Out of Scope** verbatim from `spec.md`.
7. Run Done Criteria; then hand back to `spec-kit`.

## Rules

### MUST

- Keep phase names identical to **Scope Summary** items.
- Start every phase unchecked (`[ ]`).
- Write all content in English.

### MUST NOT

- Add a phase without a matching **Scope Summary** item.
- Add or remove **Out of Scope** items.
- Write any file other than `docs/specs/feature-{NNN}/plan.md` (except the reorder in step 5).

## Handoff

| Direction | Skill | Data |
|---|---|---|
| Called by | [spec-kit](../spec-kit/SKILL.md) Step 4.2 | `spec.md` |
| Next | [spec-kit-3-tasks](../spec-kit-3-tasks/SKILL.md) (via `spec-kit`) | `plan.md` |
| Phase checkboxes updated later by | [spec-kit-executor](../spec-kit-executor/SKILL.md) | — |

## Output

`docs/specs/feature-{NNN}/plan.md`. Output language: English.

## Done Criteria

- [ ] Frontmatter matches the template.
- [ ] Phases map 1:1 to **Scope Summary**, same order, same names.
- [ ] Every phase checkbox is `[ ]`.
- [ ] No phase depends on a later phase.
- [ ] **Out of Scope** copied verbatim.
- [ ] All content is in English.

_Original author: Kallebe Lins | gh:kallebelins/my-skills_
