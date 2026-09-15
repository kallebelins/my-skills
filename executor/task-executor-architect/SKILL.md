---
name: task-executor-architect
created by: Kallebe Lins | gh:kallebelins/my-skills
description: >-
  Executes project tasks with automatic architect-skill selection (scan loaded
  skills for architect roles, read and follow the chosen SKILL.md), then updates
  the task item in place (checkbox, status, pending sub-tasks, decisions) and
  blocks ad-hoc work not registered in the task structure. Use when implementing
  a task involving architectural decisions; when marking a task done; or when the
  user asks to execute a listed task item without skill-router but with architect
  guidance.
argument-hint: "Implement task 2.1 from tasks.md"
---

# Task Executor (with architect selection)

## Purpose

Ensure demands involving architectural decisions go through an appropriate architect skill (chosen from skills loaded in memory) before implementation, and that the task artifact is updated in place when work is complete.

## When to Use

- Implement an item from `tasks/*.md`, specs, or backlog that involves structure, patterns, or technical trade-offs.
- Execute a numbered task (e.g. `2.1`) from a feature.
- Mark a task complete after implementation.
- Projects that prefer architect selection instead of `skill-router`.

**Do not use for:** feature planning or decomposition (use `spec-kit` or equivalent).

## Procedure

### 1. Automatic project architect selection

Before responding to or implementing demands involving architectural decisions,
structure, patterns, or technical trade-offs of the project, the agent must:

1. Scan skills loaded in memory (`<agent_skills>`) whose `name` or
   `description` indicates an architect role (e.g. `solution-architect`,
   `mdpe-architecture`, `demand-architect`, `architecture-analyst`,
   `architecture-proposal-architect`, `webapi-architect`, etc.).
2. Choose the most suitable one for the current demand (scope, stack, project phase).
3. Read the chosen `SKILL.md` and follow its guidance **before** investigating
   code or implementing.
4. If the user already @-mentioned a skill or specialist, skip triage and
   follow that skill directly.
5. If the demand is pure implementation with no open architectural decision,
   do not invoke an architect.
6. If two or more skills tie, ask **ONE** objective question
   (`AskQuestion`) — never ask the user to type a routing command.
7. The choice is the agent's transparent responsibility; record in the task body
   which architect was followed (integrates with section 2 — Decisions).

### 2. Update the task when complete

When finishing implementation of any task that belongs to a project task list/structure
(e.g. `tasks/*.md`, specs, backlog), before considering the work finished the agent must edit the task item to:

1. **Mark as complete**: change `[ ]` to `[x]` (or the equivalent status already used in the document, e.g. `[~]` for "in progress/partial").
2. **Brief description of what was done**: a short paragraph or status block (following the existing document pattern, e.g. `> **Status (YYYY-MM-DD):** ...`) summarizing what was implemented, which files were touched, and the validation result (build/tests).
3. **Pending items**: any remaining work must be recorded as sub-tasks with checkboxes (`- [ ] ...`) within the task itself, not only mentioned in running text.
4. **Decisions**: if any scope, trade-off, or technical choice was made during execution (e.g. package version, substitute library, feature cut), record that decision explicitly in the task body — do not leave it implicit only in code or chat history.

### 3. Tasks outside the existing structure

If the work requested by the user **does not match any task already registered**
in the project's task structure (no equivalent `[ ]`/`[x]` item exists for the request):

- The agent **must not proceed silently** with implementation.
- The agent must **ask a human** whether that task should be registered in the task structure before starting implementation, and only proceed after the answer.

### spec-kit compatibility

If the task is in `docs/specs/feature-*/tasks.md` in spec-kit format, complement section 2 with:

- A `Comment:` field right after the task's existing fields (factual, one or two lines).
- Pending sub-tasks numbered `X.X.N` nested under the parent task.
- When all tasks in a phase are `[x]`, also check off the corresponding phase checkbox in `plan.md`.
- When it is the last pending phase and `docs/backlog.md` has an entry referencing the feature's `spec.md`, mark that entry `[x]`.

### Work order

1. Confirm the request matches a registered task (section 3).
2. Select and follow an architect skill (section 1), if applicable.
3. Implement the task according to its description and criteria.
4. Update the task item in place (section 2), including which architect was followed under **Decisions**.

## Output

- Code or artifacts implemented according to the task and the chosen architect's guidance.
- Task item edited in place: checkbox marked, status/comment, pending sub-tasks and decisions recorded (including the architect's `@skill-name`).

## Verification

- [ ] Architect skill chosen and read when the demand involves an architectural decision (or skipped with documented justification).
- [ ] Architect followed recorded explicitly in the task (Decisions).
- [ ] Existing task identified before implementing; ad-hoc request blocked until human response.
- [ ] Task checkbox updated (`[x]` or equivalent).
- [ ] Summary of what was done recorded in the task body.
- [ ] Pending items opened as sub-tasks with checkboxes, not only in running text.
- [ ] Technical/scope decisions recorded explicitly in the task.
- [ ] If spec-kit: `Comment:`, phase sync in `plan.md` and backlog when applicable.
