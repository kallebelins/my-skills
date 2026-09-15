---
name: spec-kit-backlog
created by: Kallebe Lins | gh:kallebelins/my-skills
description: "Maintains docs/backlog.md — the macro, project-level list of all features (existing in code, specified via spec-kit, or brainstormed only), with [ ]/[x] checkboxes indicating execution status. Called automatically by the spec-kit orchestrator at the end of each spec, or individually by the user in 4 modes: register existing spec, brainstorming, existing-system discovery, or discovery + new-feature suggestions."
argument-hint: "Desired mode (register | brainstorming | discovery | discovery+suggestion) and, if applicable, path to an already-written spec.md or the system/domain to analyze"
---

# Spec-Kit Backlog

## Purpose

Maintain `docs/backlog.md` as the single macro-level document listing all project features — those already in code, those specified via `spec-kit`, and those that are ideas only (brainstorming) — each with a `[ ]`/`[x]` checkbox indicating whether it has been executed/delivered. This file does not replace `spec.md`/`plan.md`/`tasks.md`: it only references those artifacts and summarizes everything in one list.

## When to Use

- **Called by the orchestrator** [`spec-kit`](../spec-kit/SKILL.md), as the final step, whenever a feature's `spec.md`/`plan.md`/`tasks.md` are generated (Mode A — Register).
- **Called individually by the user** to:
  - Register in the backlog a feature whose spec was already written with `spec-kit`/`spec-kit-plan` (Mode A).
  - Brainstorm features for a new (greenfield) or existing system (Mode B).
  - Discover an existing system to inventory what already exists (Mode C).
  - Discover an existing system and, in addition to inventorying, suggest new features (Mode D).

## Common Precondition

- [ ] The path to `docs/backlog.md` in the target project is known (root of `docs/`, not `docs/specs/`).

If `docs/backlog.md` does not exist yet, create it from `spec-kit/templates/backlog.template.md` before adding any item.

## Template

Use `spec-kit/templates/backlog.template.md` for the file structure/frontmatter and for each item's format:

```
- [ ] {{Feature name}}
  - Source: {{spec-kit | discovery | brainstorming}}
  - Reference: {{docs/specs/feature-NNN/spec.md | code path | (none)}}
  - Summary: {{one line}}
```

## Modes

### Mode A — Register existing spec

Used by the `spec-kit` orchestrator (automatic) or when the user asks to "add to backlog" an already-specified feature.

1. Precondition: `docs/specs/feature-{NNN}/spec.md` exists (written by `spec-kit-spec`).
2. Read the title and "Scope Summary" section of `spec.md` to build a one-line summary.
3. Check whether an entry already exists in `docs/backlog.md` whose Reference points to the same `spec.md` — if so, do not duplicate (idempotent); only update the Summary if outdated.
4. Otherwise, add a new `- [ ]` entry (not complete — the spec was written, but execution has not finished), with:
   - Source: `spec-kit`
   - Reference: `docs/specs/feature-{NNN}/spec.md`
   - Summary: the line extracted from Scope Summary/title.
5. Confirmation before writing is **not required** in this mode — it is an automatic/idempotent operation that only mirrors an artifact already approved by the user (the spec).

### Mode B — Feature brainstorming

Used to help identify features for a new (greenfield) system or add ideas to an existing one.

1. If the domain, target users, or system goal are unclear in the conversation, ask objective questions before proposing the list — do not invent business scope.
2. Propose a list of candidate features, each with a short name and a one-line summary.
3. **Present the full list to the user and wait for confirmation (or adjustments) before writing to `docs/backlog.md`.**
4. After confirmation, add one `- [ ]` entry per accepted feature:
   - Source: `brainstorming`
   - Reference: `(none)`
   - Summary: the proposed line (adjusted as the user requests).
5. Make clear to the user that these are ideas not yet specified — to formalize any of them, run `spec-kit` on the item, and Mode A of this skill will then update the entry (Source becomes `spec-kit`, Reference points to the generated `spec.md`).

### Mode C — Existing-system discovery (inventory only)

Used when the user only wants to know which features already exist in a system, without suggestions.

1. Read the system's source code (routes/controllers, UI components, use cases, exposed endpoints) to identify already-implemented features.
2. For each identified feature, add a `- [x]` entry (already implemented/delivered):
   - Source: `discovery`
   - Reference: representative code path (e.g. main controller/route/component file).
   - Summary: one line describing what the feature does, based on the code read.
3. Do not invent features not evidenced in the code — if something is uncertain, ask the user instead of assuming.
4. Present the inventoried list to the user before writing to `docs/backlog.md`, for confirmation that the system reading is correct.

### Mode D — Discovery + new-feature suggestions

Combines Modes C and B for an existing system: inventories what exists and suggests gaps/next steps.

1. Execute Mode C (steps 1-2) to list existing features (`- [x]`).
2. Based on what was found, identify plausible gaps or extensions and build a suggestion list (same process as Mode B, step 2).
3. Present both lists to the user, clearly separated (existing vs. suggested), for confirmation before writing.
4. After confirmation, write to `docs/backlog.md`:
   - Existing items: `- [x]`, Source: `discovery`, Reference: code path.
   - Accepted suggested items: `- [ ]`, Source: `brainstorming`, Reference: `(none)`.

## Content Rules

- Never remove or reorder existing entries in `docs/backlog.md` — only add new ones or update the checkbox/Summary of an existing entry when the item itself changes state.
- An item is only marked `[x]` when the feature is actually delivered/executed (already in production, or all phases of the referenced `plan.md` are complete) — never mark `[x]` just because the spec was written.
- Keep all 3 fields (Source/Reference/Summary) on every entry, even when Reference is `(none)`.
- Update the frontmatter `last_updated` field whenever the file is modified.

## Output

Create or update `docs/backlog.md` at the root of the target project's `docs/` folder.

## Self-Check Before Finishing

- [ ] `docs/backlog.md` frontmatter matches the template
- [ ] No duplicate entries (same Reference pointing to the same `spec.md`/path)
- [ ] Every item has Source, Reference, and Summary filled in
- [ ] Checkbox for each new item reflects the mode used (A/B → `[ ]`; C → `[x]`; D → mixed, per item)
- [ ] In Modes B/C/D, the list was presented and confirmed by the user before writing
- [ ] No existing entry was removed, reordered, or had its meaning changed unnecessarily
- [ ] `docs/backlog.md` remains the project's single backlog file (do not create one per feature)
