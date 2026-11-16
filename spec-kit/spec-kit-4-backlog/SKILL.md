---
name: spec-kit-4-backlog
description: "Spec-kit sub-skill 4 — maintains docs/backlog.md, the single project-level list of all features (existing in code, specified via spec-kit, or brainstormed), each with a [ ]/[x] checkbox for delivery status. Four modes: A register an existing spec (automatic, called by spec-kit), B brainstorming, C discovery of an existing system (inventory only), D discovery + suggestions. WHEN: register spec in backlog, add feature to backlog, brainstorm features, inventory existing features, suggest new features. DO NOT USE FOR: writing spec/plan/tasks, implementing features."
argument-hint: "Mode (A register | B brainstorming | C discovery | D discovery+suggestions) and, when applicable, the spec.md path or the system/module to analyze"
---

# Spec-Kit Sub-Skill 4 — Backlog

## Purpose

Keep `docs/backlog.md` as the only macro-level list of project features. It references `spec.md` files and code paths; it never replaces them.

## When to Use

- Called by `spec-kit` Step 6 (Mode A).
- The user asks to register an existing spec (Mode A), brainstorm features (Mode B), inventory an existing system (Mode C) or inventory + suggest (Mode D).

## When Not to Use

- Writing `spec.md`, `plan.md` or `tasks.md` → `spec-kit`.
- Marking a feature done after implementation → done by `spec-kit-executor`.

## Inputs

| Input | Required | Source | If missing |
|---|---|---|---|
| Mode | Yes | `spec-kit` or user | Ask the user (A/B/C/D). |
| `spec.md` path | Mode A | `spec-kit` or user | Ask the user. |
| System/module to analyze | Modes C/D | User | List folders with build manifests and ask. |
| Domain, target users, goals | Mode B | Conversation | Ask the user. |

## Preconditions

- [ ] Backlog path is `docs/backlog.md` at the `docs/` root (not under `docs/specs/`).
- [ ] If `docs/backlog.md` does not exist → create it from [backlog.template.md](../spec-kit/templates/backlog.template.md) before adding items.

## Procedure

### Mode A — Register existing spec (no confirmation needed; idempotent)

1. Read the title and **Scope Summary** of the given `spec.md`.
2. Search `docs/backlog.md` for an entry whose **Reference** is that `spec.md` path.
3. If found → do not duplicate; update **Summary** only if outdated. Stop.
4. If not found → append `- [ ]` with Origin `spec-kit`, Reference `docs/specs/feature-{NNN}/spec.md`, Summary = one line from title/Scope Summary.

### Mode B — Brainstorming

1. If domain, users or goals are unclear → ask before proposing.
2. Propose candidate features: short name + one-line summary each.
3. Present the full list and wait for confirmation or edits.
4. After confirmation → append `- [ ]` per accepted item with Origin `brainstorming`, Reference `(none)`.
5. Tell the user these items are not specified yet; running `spec-kit` on one will update it via Mode A.

### Mode C — Discovery (inventory only)

1. Read routes/controllers, UI components, use cases and exposed endpoints of the system.
2. For each feature evidenced in code → draft `- [x]` with Origin `discovery`, Reference = representative code path, Summary based on the code read.
3. If something is uncertain → ask; do not include unverified features.
4. Present the inventory and wait for confirmation before writing.

### Mode D — Discovery + suggestions

1. Run Mode C steps 1–3.
2. From the gaps found, draft suggestions as in Mode B step 2.
3. Present both lists clearly separated (existing vs suggested) and wait for confirmation.
4. After confirmation → write existing items as `- [x]` (Origin `discovery`) and accepted suggestions as `- [ ]` (Origin `brainstorming`, Reference `(none)`).

### Matching existing entries

When matching or updating, accept legacy Portuguese field labels (`Origem`, `Referência`, `Resumo`, `(nenhuma)`) as equivalent to `Origin`, `Reference`, `Summary`, `(none)`. Write new entries with English labels and English text.

## Rules

### MUST

- Keep Origin, Reference and Summary on every new entry (Reference may be `(none)`).
- Update `last_updated` in the frontmatter on every change.
- Mark `[x]` only when the feature is actually delivered (exists in code, or all `plan.md` phases are done).

### MUST NOT

- Remove or reorder existing entries.
- Mark `[x]` just because a spec was written.
- Write in Modes B/C/D without user confirmation.
- Create per-feature backlog files.
- Invent features not evidenced in code (Mode C) or not accepted by the user (Modes B/D).

## Handoff

| Direction | Skill | Data |
|---|---|---|
| Called by | [spec-kit](../spec-kit/SKILL.md) Step 6 | `spec.md` path (Mode A) |
| Entry checked later by | [spec-kit-executor](../spec-kit-executor/SKILL.md) | When the last phase completes |

## Output

`docs/backlog.md` created or updated. Output language: English.

## Done Criteria

- [ ] Frontmatter matches the template.
- [ ] No duplicate entries (same Reference).
- [ ] Every new entry has Origin, Reference, Summary, written in English.
- [ ] New checkboxes match the mode (A/B → `[ ]`; C → `[x]`; D → per item).
- [ ] Modes B/C/D were confirmed by the user before writing.
- [ ] No existing entry was removed, reordered or changed in meaning.

_Original author: Kallebe Lins | gh:kallebelins/my-skills_
