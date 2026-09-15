---
name: task-executor-m24h
created by: Kallebe Lins | gh:kallebelins/my-skills
description: >-
  Executes project tasks with automatic Mvp24Hours specialist routing via
  skill-router, then updates the task item in place (checkbox, status, pending
  sub-tasks, decisions) and blocks ad-hoc work not registered in the task
  structure. Use when implementing a task from tasks.md, specs, or backlog in
  Mvp24Hours projects; when marking a task done; or when the user asks to
  execute or implement a listed task item.
argument-hint: "Implement task 2.1 from tasks.md"
---

# Task Executor (with skill-router)

## Purpose

Ensure every task execution in projects with the Mvp24Hours catalog goes through automatic specialist routing (`skill-router`) and that the task artifact is updated in place when work is complete.

## When to Use

- Implement an item from `tasks/*.md`, specs, or backlog.
- Execute a numbered task (e.g. `2.1`) from a feature.
- Mark a task complete after implementation.
- Implementation requests that may involve Mvp24Hours domains (persistence, CQRS, messaging, tests, security, etc.).

**Do not use for:** feature planning or decomposition (use `spec-kit` or equivalent).

## Procedure

### 1. Automatic specialist selection (skill-router)

Whenever a demand involves architecture, implementation, or decisions within the
Mvp24Hours ecosystem (or any specialist/skill catalog available in the environment), the agent must **automatically invoke the specialist routing mechanism (`skill-router`)** before responding or implementing, without waiting for the user to type `/skill-router` or mention the router manually.

- If the demand appears to fit a Mvp24Hours catalog domain
  (architecture, persistence, messaging, CQRS, tests, security, etc.),
  invoke `skill-router` (or the equivalent triage/handoff available
  in this environment) **before** investigating code or implementing, and follow the
  returned handoff guidance (which specialist to assume).
- If the user already explicitly mentions a specialist (e.g.
  `@specialist-name`) or a specific rule/skill, skip triage and
  follow that specialist directly.
- If the demand is generic software engineering with no relation to
  the Mvp24Hours catalog, routing is not required.
- Never ask the user to type the routing command — the decision of
  which specialist to use is the agent's responsibility, transparently.

**Concrete action:** when applicable, `Read` the `skill-router/SKILL.md` file (global or environment skill) and follow the returned handoff before investigating code or implementing.

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
2. Apply specialist routing (section 1), if applicable.
3. Implement the task according to its description and criteria.
4. Update the task item in place (section 2).

## Output

- Code or artifacts implemented according to the task.
- Task item edited in place: checkbox marked, status/comment, pending sub-tasks and decisions recorded.

## Verification

- [ ] skill-router invoked when the demand fits the Mvp24Hours catalog (or skipped with documented justification).
- [ ] Existing task identified before implementing; ad-hoc request blocked until human response.
- [ ] Task checkbox updated (`[x]` or equivalent).
- [ ] Summary of what was done recorded in the task body.
- [ ] Pending items opened as sub-tasks with checkboxes, not only in running text.
- [ ] Technical/scope decisions recorded explicitly in the task.
- [ ] If spec-kit: `Comment:`, phase sync in `plan.md` and backlog when applicable.
