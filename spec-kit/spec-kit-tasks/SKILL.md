---
name: spec-kit-tasks
created by: Kallebe Lins | gh:kallebelins/my-skills
description: "Sub-step of the spec-kit orchestrator (spec-kit/SKILL.md) — writes tasks.md, the last file in the sequence, using the mandatory phased task item format. Also defines the execution protocol every agent must follow when implementing a task from tasks.md (marking done, commenting, opening sub-tasks for pending work, syncing docs/backlog.md when the feature completes)."
argument-hint: "Called by spec-kit orchestrator with: plan.md and spec.md already written, architecture reference resolved. Also invoked directly whenever an agent is asked to implement a task from an existing tasks.md."
---

# Spec-Kit Sub-Skill — tasks.md

## Purpose

Write `tasks.md`: the granular, one-action-per-task breakdown, organized by **Phase** (matching `plan.md`), where every task carries its own architecture/implementation detail inline — there is no separate `constitution.md`/`implementation.md` file anymore. `tasks.md` is also the live tracking artifact: it is edited in place as work is executed (see "Execution Protocol" below), there is no external PR/progress-checklist to sync.

## Preconditions (verify before writing)

- [ ] `plan.md` exists with its ordered phases
- [ ] `spec.md` exists with business rules and measurable acceptance criteria
- [ ] Architecture reference resolved (`spec-kit` orchestrator Step 2 — `docs/architecture.md` or the pattern agreed with the user)

## Template

Use `spec-kit/templates/tasks.template.md`.

## Mandatory Task Item Format

Every task **must** follow this exact structure — one action per task, no exceptions:

```
- [ ] X.X - Task name
Description: {{what to do}}
Architecture/Implementation: {{layer, pattern, convention and relevant commands, based on the resolved architecture reference}}
Input: {{reference to spec.md#..., if any}}
Output: {{artifact/file to create or modify}}
Test scenarios: {{if any}}
Acceptance criteria: {{measurable}}
```

Where:
- `X` = number of the "Phase" (matches the phase order in `plan.md`, 1-based)
- `X.X` = sequence number within that phase (1-based)
- Each phase starts with a `## Phase X — {{phase name}}` heading — the name must match `plan.md` exactly

## Content Rules

- **Description**: one clear action (create/modify one file, implement one endpoint, one component, etc.) — never bundle multiple unrelated actions into one task.
- **Architecture/Implementation**: MANDATORY, never empty. This is where the architecture/implementation detail that used to live in separate `constitution.md`/`implementation.md` files now goes — grounded in the architecture reference resolved by the orchestrator (`docs/architecture.md` or the pattern agreed with the user). Never invent a convention not present in that reference.
- **Input**: link to the specific `spec.md` section this task implements. Omit only if truly none.
- **Output**: the exact artifact/file path to create or modify.
- **Test scenarios**: pull from `spec.md`'s edge cases / error handling for this specific action, when applicable. Omit only if truly none apply.
- **Acceptance criteria**: must be individually measurable and must trace back to one of `spec.md`'s Acceptance Criteria.
- Tasks within a phase are ordered so that dependencies (e.g., entity before service, service before controller/component) come first.

## Output

Write `docs/specs/feature-{NNN}/tasks.md`.

## Self-Check Before Handing Back to Orchestrator

- [ ] Frontmatter matches the template
- [ ] Every phase heading matches a `plan.md` phase name, in the same order
- [ ] Every task has all fields (Description/Architecture-Implementation/Input/Output/Acceptance criteria); "Test scenarios" may be omitted only when truly none apply
- [ ] Every task numbering is `X.X` with `X` = phase number
- [ ] Every acceptance criterion is measurable and traceable to `spec.md`
- [ ] No task bundles more than one action

Once this file is written and self-checked, hand control back to `spec-kit` for its Step 5 (final self-verification across `spec.md`/`plan.md`/`tasks.md`).

## Execution Protocol (when implementing an existing task)

This section applies whenever any agent implements a task already listed in an existing `tasks.md` — this is the local, single-repo replacement for the old `code-implementation` skill. There is no separate repo, PR, or progress-checklist to sync: `tasks.md` itself is the record of progress and is edited directly.

Work one task at a time, in phase/sequence order (Phase 1 before Phase 2, X.1 before X.2):

1. Read the task's `Description`, `Architecture/Implementation`, `Input` and `Acceptance criteria` in full before writing any code.
2. Implement exactly what `Description` and `Architecture/Implementation` describe — nothing more, nothing less.
3. After implementing, update the task in `tasks.md`:
   - Mark it done: change `- [ ]` to `- [x]`.
   - Add a `Comment:` line right after the task's existing fields, stating concretely what was done (files touched, key decisions) — factual, one or two lines, never restating the `Description`.
   - If any acceptance criterion could not be fully met, or new work was discovered while implementing (uncovered edge case, follow-up refactor, missing dependency, etc.), do not drop it and do not mark the parent task done. Instead add one sub-task per pending item nested directly under it, using bracket checkboxes and nested numbering:
     ```
     - [ ] X.X.N - {{pending item name}}
     Description: {{what remains to be done}}
     ```
   - When every task in a phase is `[x]`, also check off that phase's own checkbox in `plan.md`.
   - When that was the **last remaining unchecked phase** in `plan.md` (i.e. all phases are now `[x]`), look for `docs/backlog.md` at the project's `docs/` root. If it exists and has an entry whose Reference points to this feature's `spec.md`, mark that entry `[x]` too. If `docs/backlog.md` doesn't exist or has no matching entry, skip this silently — do not create the file from here (that is `spec-kit-backlog`'s job).
4. Never renumber or reorder existing tasks when adding sub-tasks or new comments — only append.
5. Never mark a task `[x]` if its `Acceptance criteria` are not satisfied — add sub-tasks instead and leave the parent task open until they are resolved.
