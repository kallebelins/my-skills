---
name: spec-kit-executor
description: "Executes one registered task (from a feature tasks.md, the fix plan of a bug report docs/bugs/bug-NNN-*.md, a spec or the backlog) and updates its checkbox, Comment, pending sub-tasks and decisions; syncs phase/backlog checkboxes (or the bug report status) and records a concise completion summary in each affected project's CHANGELOG only when the entire backlog item/spec/bug fix is delivered, using the spec if no backlog entry exists. Bug fixes run straight from the report, without creating a feature. Blocks unregistered work. WHEN: implement task X.Y, execute a task from tasks.md, fix bug-NNN, execute a task from a bug fix plan, mark a task as done, continue a registered task, record completion in CHANGELOG. DO NOT USE FOR: planning or decomposing features (use spec-kit), analyzing bugs or planning their fix (use qa-bug-analysis), unregistered work."
argument-hint: "Task identifier and file, e.g. \"Task 2.1 from docs/specs/feature-012/tasks.md\" or \"Task 1.1 from docs/bugs/bug-002-xxx.md\""
---

# Spec-Kit Executor

## Purpose

Enforce disciplined execution: implement exactly one registered task, then record the result in the task artifact. When the entire backlog item/spec is delivered, record its summary in each affected project's CHANGELOG. Unregistered work is blocked until a human decides.

## When to Use

- Implement a task listed in `docs/specs/feature-*/tasks.md`, in the fix plan (section 11) of a bug report `docs/bugs/bug-NNN-*.md`, another task list, or `docs/backlog.md`.
- Mark a task as done after implementation.

## When Not to Use

- Planning, specifying or decomposing a feature → hand off to `spec-kit`.
- Analyzing a bug or planning its fix → hand off to `qa-bug-analysis`.

## Inputs

| Input | Required | Source | If missing |
|---|---|---|---|
| Task identifier (e.g. `2.1`) | Yes | User | Ask the user. |
| Task file | Yes | User | Search `docs/specs/*/tasks.md` (or `docs/bugs/bug-*.md` when the user mentions a bug) for the identifier/name; if zero or several matches → ask. |

## Preconditions

- [ ] The requested work matches an existing task item (`[ ]`, `[~]` or `[x]` with pending sub-tasks).
- [ ] All earlier tasks in the same phase are `[x]`, or the user confirmed out-of-order execution.

## Procedure

1. Locate the task. If no registered task matches the request → stop; ask the user whether to register it through `spec-kit` first (or `qa-bug-analysis` for a bug). Do not implement.
2. Read the full task: Description, Architecture/Implementation, Input, Output, Test scenarios, Acceptance criteria.
3. Read `architecture_ref` from the feature's `spec.md`/`tasks.md` frontmatter and the referenced `spec.md` sections.
4. Implement exactly the task scope — nothing more, nothing less.
5. Run the validation required by the task (build/tests). Record the result.
6. If every acceptance criterion is met → change `- [ ]` to `- [x]`.
7. If any criterion is not met or new work was discovered → keep the parent `- [ ]` and append one nested sub-task per pending item:
   ```
   - [ ] X.Y.N - <name of the pending item>
   Description: <what is missing>
   ```
8. Add `Comment: <files changed, main decisions, validation result>` right after the task's last field (one or two factual lines; do not restate Description).
9. If a scope/technical decision was made (library, version, trade-off, scope cut) → record it in the Comment as `Decision: ...`.
10. If every task of the phase is `[x]` → check the phase in `plan.md`.
11. If that was the last unchecked phase and every task and acceptance criterion of the entire item/spec is met → open `docs/backlog.md`; if an entry references this feature's `spec.md`, mark it `[x]` and use the completed item as the summary source. If the file or entry does not exist → use the completed spec as the source, without creating a backlog. In either case, perform the completion CHANGELOG procedure below. Intermediate tasks do not generate completion entries. On resuming an already completed item/spec, verify its CHANGELOG entries using the same procedure.
12. If the backlog entry was marked `[x]` and the project uses an external task tracker (for example Jira, Azure DevOps, ServiceNow) with an available integration skill/tool → ask the user whether to update the linked tracker item (close it). If only a task was completed and the entry references a tracker item → offer to add a progress note. Never write to the tracker without confirmation. Report any pending CHANGELOG update explicitly; do not present the documentary closure as complete while it is blocked.

### Completion CHANGELOG

1. Identify the projects actually affected by the delivered changes, not merely mentioned in the spec. Frontend-only changes go only to the frontend CHANGELOG; backend-only changes go only to the backend CHANGELOG. If both are affected, write one project-specific summary in each. For documentation-only work with no frontend/backend impact, ask the user for the destination before writing; do not add unrelated entries to application histories.
2. Locate and read the actual change history in each affected project. Preserve its structure, sections and existing entries. A file named CHANGELOG containing a template or another document is not a change history: preserve it and continue looking; inspect its current content rather than overwriting it based on its name.
3. If no history exists, create `CHANGELOG.md` at the affected project's root. If that path is occupied by a non-history document, multiple histories are equally plausible, or the project/destination is uncertain, ask the user before writing; never overwrite another document or guess a destination.
4. Write a concise summary in English of the delivered result, identifying the backlog item/spec (for example, `feature-NNN`). Use the completed backlog item as the source, or the completed spec when the backlog file or corresponding entry is absent. Limit each summary to that project's actual impact; do not copy tasks, logs or the full spec, and do not claim pending work as delivered.
5. Before inserting, check for an entry for the same item/spec in that project's history. On a resumed completion, keep a single entry; complement it only if necessary, preserving unrelated records. Do not duplicate the entry or modify other projects' histories.
6. Verify that every required summary was saved in its intended history. If reading or writing fails, report the error and destination, record the documentary pending item in the task's Comment and as a checkbox sub-task, and do not claim successful registration. Preserve valid technical conclusions, but keep documentary closure pending until resolved. Never silently skip a required history update.

### Bug fix plans (`docs/bugs/bug-NNN-*.md`)

The fix plan in section 11 of a report written by `qa-bug-analysis` is a registered task list. Execute it directly from the report; **never create a feature folder, `spec.md`, `plan.md`, `tasks.md` or a `docs/backlog.md` entry for a bug**.

1. Precondition: report **Status** is `Ready for fix` or `Fix in progress`. If it is `Awaiting information` or `Requires specification` (or section 11 has no tasks) → stop and point to `qa-bug-analysis` (complete the analysis) or `spec-kit` (section 11.1), respectively.
2. Read the report sections cited in the task's **Input** (8, 9, E-XX, H-XX, 4) instead of `spec.md`; use **Architecture reference** and **Technical skills for execution** of section 11 as `architecture_ref` and technical skills.
3. Apply steps 2–9 of the Procedure. Phases are the `### Phase X` headings of section 11; there is no `plan.md` to sync.
4. When starting the first task, set the header **Status** to `Fix in progress`.
5. When every task of section 11 is `[x]` and every `AC-XX` of section 9 is met → mark those AC checkboxes `[x]`, set **Status** to `Fixed` and **Readiness** accordingly, and run the completion CHANGELOG procedure identifying the entry by `bug-NNN` (source: the report). Intermediate tasks do not generate entries.
6. Task tracker: if the header line `Tracker:` references an item → on `Fixed`, ask whether to close it; after an intermediate task, offer a progress note. If it is `Not linked` → on `Fixed`, offer to link/close one when the project uses a tracker. Never write to the tracker without confirmation.
7. Work beyond the fix plan (new scope, new rule) is unregistered: stop and ask whether to update the report via `qa-bug-analysis` or plan it via `spec-kit`.

### Non spec-kit task lists

For other task files, apply steps 1–9 using the document's existing conventions (e.g. `[~]` for partial, `> **Status (YYYY-MM-DD):** ...` blocks). When a corresponding backlog item/spec exists, verify all its tasks and acceptance criteria before applying the completion CHANGELOG procedure and the applicable backlog/tracker updates. Finishing an intermediate task alone never triggers an integral delivery entry.

### Legacy labels

Existing `tasks.md`/`plan.md` files may use legacy Portuguese labels (`Descrição`, `Arquitetura/Implementação`, `Entrada`, `Saída`, `Cenários de teste`, `Critérios de aceitação`, `Comentário`, `Decisão`, `Fase`, `CA-XX`). Treat them as equivalent to the English labels (`Description`, `Architecture/Implementation`, `Input`, `Output`, `Test scenarios`, `Acceptance criteria`, `Comment`, `Decision`, `Phase`, `AC-XX`). When updating such a file, keep the label language already used in that file for consistency, but write the free text (comments, decisions, sub-tasks) in English.

## Rules

### MUST

- Work one task at a time, in phase/sequence order.
- Record pending work as checkbox sub-tasks, never only in prose.
- Record decisions explicitly in the task.
- Record a concise English completion summary, identified by item/spec, in each actually affected project's CHANGELOG only after integral delivery; use the spec when no backlog entry exists.
- Preserve real histories and non-history documents, avoid duplicate completion entries, and surface ambiguous destinations or read/write failures explicitly.

### MUST NOT

- Implement unregistered work.
- Create a feature, `spec.md`, `plan.md`, `tasks.md` or backlog entry to execute a bug fix plan.
- Mark `[x]` when any acceptance criterion is unmet.
- Renumber, reorder or delete existing tasks; only append.
- Create `docs/backlog.md` (that belongs to `spec-kit-4-backlog`).

## Handoff

| Direction | Skill | Data |
|---|---|---|
| Unregistered work → | [spec-kit](../spec-kit/SKILL.md) | Feature request to plan |
| Bug fix plan defined by | [qa-bug-analysis](../qa-bug-analysis/SKILL.md) | Section 11 of `docs/bugs/bug-NNN-*.md` |
| Task format defined by | [spec-kit-3-tasks](../spec-kit-3-tasks/SKILL.md) | — |
| Backlog format defined by | [spec-kit-4-backlog](../spec-kit-4-backlog/SKILL.md) | — |

## Output

- Code/artifacts implementing the task.
- Task item updated in place (checkbox, Comment, decisions, sub-tasks); `plan.md` and `docs/backlog.md` synced when applicable.
- On integral delivery: a concise, traceable summary in each affected project's CHANGELOG, sourced from the backlog item or, if absent, the spec; otherwise an explicit documentary impediment and pending sub-task.
- Output language: English for artifacts and messages to the user (except when keeping legacy Portuguese labels of an existing file).

## Done Criteria

- [ ] Registered task identified before implementing; ad-hoc work blocked until a human answered.
- [ ] Checkbox updated correctly.
- [ ] Comment with files, decisions and validation result added.
- [ ] Pending items opened as checkbox sub-tasks.
- [ ] Phase checkbox in `plan.md` and backlog entry synced when applicable.
- [ ] For integral delivery, one concise English summary identified by item/spec saved in each affected project's real CHANGELOG, using the spec if no backlog entry exists; no entries for intermediate tasks or unaffected projects.
- [ ] Existing history format and non-history documents preserved; resumed completions do not duplicate entries.
- [ ] Ambiguous destinations clarified and read/write failures reported with documentary pending sub-tasks; no false success claim.

_Original author: Kallebe Lins | gh:kallebelins/my-skills_
