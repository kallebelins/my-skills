---
name: task-executor
created by: Kallebe Lins | gh:kallebelins/my-skills
description: >-
  Executes project tasks and updates the task item in place (checkbox, status,
  pending sub-tasks, decisions), blocking ad-hoc work not registered in the task
  structure. No specialist routing. Use when implementing a task from tasks.md,
  specs, or backlog; when marking a task done; or when the user asks to execute
  or implement a listed task item without Mvp24Hours skill-router triage.
argument-hint: "Implement task 2.1 from tasks.md"
---

# Task Executor

## Purpose

Enforce discipline in task execution: implement the registered item, update the task artifact in place when done, and block unregistered ad-hoc work.

## When to Use

- Implement an item from `tasks/*.md`, specs, or backlog.
- Execute a numbered task (e.g. `2.1`) from a feature.
- Mark a task complete after implementation.
- Projects that do not use automatic specialist routing (`skill-router`).

**Do not use for:** feature planning or decomposition (use `spec-kit` or equivalent).

## Procedure

### 1. Update the task when complete

When finishing implementation of any task that belongs to a project task list/structure
(e.g. `tasks/*.md`, specs, backlog), before considering the work finished the agent must edit the task item to:

1. **Mark as complete**: change `[ ]` to `[x]` (or the equivalent status already used in the document, e.g. `[~]` for "in progress/partial").
2. **Brief description of what was done**: a short paragraph or status block (following the existing document pattern, e.g. `> **Status (YYYY-MM-DD):** ...`) summarizing what was implemented, which files were touched, and the validation result (build/tests).
3. **Pending items**: any remaining work must be recorded as sub-tasks with checkboxes (`- [ ] ...`) within the task itself, not only mentioned in running text.
4. **Decisions**: if any scope, trade-off, or technical choice was made during execution (e.g. package version, substitute library, feature cut), record that decision explicitly in the task body — do not leave it implicit only in code or chat history.

### 2. Tasks outside the existing structure

If the work requested by the user **does not match any task already registered**
in the project's task structure (no equivalent `[ ]`/`[x]` item exists for the request):

- The agent **must not proceed silently** with implementation.
- The agent must **ask a human** whether that task should be registered in the task structure before starting implementation, and only proceed after the answer.

### spec-kit compatibility

If the task is in `docs/specs/feature-*/tasks.md` in spec-kit format, complement section 1 with:

- A `Comment:` field right after the task's existing fields (factual, one or two lines).
- Pending sub-tasks numbered `X.X.N` nested under the parent task.
- When all tasks in a phase are `[x]`, also check off the corresponding phase checkbox in `plan.md`.
- When it is the last pending phase and `docs/backlog.md` has an entry referencing the feature's `spec.md`, mark that entry `[x]`.

### Work order

1. Confirm the request matches a registered task (section 2).
2. Read the task in full (description, criteria, architecture/implementation when present).
3. Implement exactly the task scope.
4. Update the task item in place (section 1).

## Output

- Code or artifacts implemented according to the task.
- Task item edited in place: checkbox marked, status/comment, pending sub-tasks and decisions recorded.

## Verification

- [ ] Existing task identified before implementing; ad-hoc request blocked until human response.
- [ ] Task checkbox updated (`[x]` or equivalent).
- [ ] Summary of what was done recorded in the task body.
- [ ] Pending items opened as sub-tasks with checkboxes, not only in running text.
- [ ] Technical/scope decisions recorded explicitly in the task.
- [ ] If spec-kit: `Comment:`, phase sync in `plan.md` and backlog when applicable.
