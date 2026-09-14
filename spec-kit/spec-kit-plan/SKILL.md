---
name: spec-kit-plan
created by: Kallebe Lins
description: "Sub-step of the spec-kit orchestrator (spec-kit/SKILL.md) — writes plan.md only. Not meant to be invoked standalone; runs after spec-kit-spec and before spec-kit-tasks in the spec-kit sequence."
argument-hint: "Called by spec-kit orchestrator with: spec.md already written"
---

# Spec-Kit Sub-Skill — plan.md

## Purpose

Write `plan.md`: the dependency-ordered list of phases ("Fases") that organizes `spec.md` for execution. **Phases MUST be derived from `spec.md`'s "Scope Summary" list — never invented independently.** Each phase carries its own `[ ]` checkbox so execution progress can be tracked at the phase level, in addition to the per-task checkboxes in `tasks.md`.

## Preconditions (verify before writing)

- [ ] `spec.md` exists and has a non-empty "Scope Summary" section

If `spec.md` is missing or has no "Scope Summary", stop and return to the orchestrator.

## Template

Use `spec-kit/templates/plan.template.md`.

## Content Rules

- Create one phase (`- [ ] Fase N — {{name}}`) per item in `spec.md`'s "Scope Summary", in the same order, using the same name.
- Every phase starts unchecked (`[ ]`) — it is only checked off later, during execution, once every task belonging to that phase in `tasks.md` is marked done (see `spec-kit-tasks`'s execution protocol).
- For each phase, state:
  - **Depende de**: dependencies on earlier phases (if any)
  - **Entrega**: what it delivers, referencing the specific `spec.md` sections it covers
- **Out of Scope**: copy verbatim from `spec.md`'s "Out of Scope" section — do not add or remove items here.
- Do not add a phase that has no corresponding "Scope Summary" item in `spec.md`.

## Output

Write `docs/specs/feature-{NNN}/plan.md`.

## Self-Check Before Handing Back to Orchestrator

- [ ] Frontmatter matches the template
- [ ] Every phase name matches a `spec.md` "Scope Summary" item 1:1, in the same order
- [ ] Every phase checkbox starts as `[ ]`
- [ ] Phase order respects dependencies (no phase depends on a later one)
- [ ] "Out of Scope" is copied verbatim from `spec.md`

Once this file is written and self-checked, hand control back to `spec-kit` to proceed to `spec-kit-tasks`.
