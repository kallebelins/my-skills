---
name: spec-kit-spec
created by: Kallebe Lins | gh:kallebelins/my-skills
description: "Sub-step of the spec-kit orchestrator (spec-kit/SKILL.md) — writes spec.md only. Not meant to be invoked standalone; runs first in the spec-kit sequence, before spec-kit-plan."
argument-hint: "Called by spec-kit orchestrator with: feature folder resolved, architecture reference resolved, business context gathered"
---

# Spec-Kit Sub-Skill — spec.md

## Purpose

Write `spec.md`: the complete specification — business rules, contracts/data models (when applicable), edge cases, error handling, and measurable acceptance criteria — that `plan.md` and `tasks.md` will depend on directly. Consolidate every piece of business/market context gathered by the orchestrator as completely as possible; this file is the single source of truth for scope.

## Preconditions (verify before writing)

- [ ] Feature folder `docs/specs/feature-{NNN}/` resolved (orchestrator Step 1)
- [ ] Architecture reference resolved (orchestrator Step 2) — not needed for content, but must be recorded in frontmatter
- [ ] Business context gathered (orchestrator Step 3): user's conversation description and, if provided, a context file already read

If any precondition is missing, stop and return to the `spec-kit` orchestrator — do not fabricate scope from assumptions.

## Template

Use `spec-kit/templates/spec.template.md` as the exact structure and frontmatter to fill in.

## Content Rules

- **Sources**: list what was used to write this spec (conversation description, and/or the path of any context file read).
- **Scope Summary**: enumerate the capability groups this spec covers — this list is what `plan.md` phases will map to 1:1. Keep each item small and named clearly (it becomes a phase name later).
- **Out of Scope**: explicit exclusions — `plan.md` will copy these verbatim.
- **Business Rules**: consolidate every business rule mentioned across all sources as exhaustively as possible — organize by topic, do not drop details for brevity, do not merge distinct rules into one bullet.
- **Contracts**: only include when the feature has APIs, components, or integration points. Skip the section entirely if not applicable — do not invent contracts.
- **Data Models**: only include when the feature involves persisted or transferred data. Skip if not applicable.
- **Edge Cases**: derive from the business rules — what happens at boundaries, invalid input, concurrent access, empty states, etc.
- **Error Handling**: how each failure mode surfaces to the user/caller.
- **Acceptance Criteria**: measurable only (reject vague criteria like "should work correctly"); each one must be individually referenceable by a task in `tasks.md`.
- **Open Questions**: any gap in the sources that blocks a measurable criterion — list it here and ask the user instead of guessing.

## Output

Write `docs/specs/feature-{NNN}/spec.md`.

## Self-Check Before Handing Back to Orchestrator

- [ ] Frontmatter matches the template (`doc`, `feature`, `status`, `architecture_ref`, `generated_by`)
- [ ] No `{{placeholder}}` remaining
- [ ] "Scope Summary" list exists and each item is a short, plannable name
- [ ] Every business rule traces to the conversation or the context file — nothing fabricated
- [ ] Contracts/Data Models sections present only when applicable to this feature
- [ ] Acceptance criteria are individually measurable
- [ ] "Open Questions" is empty, or the user has already answered every item listed there

Once this file is written and self-checked, hand control back to `spec-kit` to proceed to `spec-kit-plan`.
