# Spec-Driven Workflow

Classify every request as **planning** or **execution**. Do not mix them in one pass.

## Planning → `spec-kit`

Triggers: plan a feature, write a spec, `/spec`, decompose before coding.

1. If `docs/architecture.md` is missing, run `spec-kit-architecture` first (or suggest it).
2. Follow the `spec-kit` skill — do **not** write application code.
3. Produce in order: `spec.md` → `plan.md` → `tasks.md` under `docs/specs/feature-{NNN}/`, then register in `docs/backlog.md`.
4. Read and follow the installed `spec-kit` skill before acting.

## Execution → `task-executor`

Triggers: implement a task, mark done, execute an item from `tasks.md` / backlog.

1. Read and follow the installed `task-executor` skill before acting.
2. Implement only registered tasks; if the work is not in the task structure, ask before proceeding.
3. When done: mark `[x]`, record status, pending sub-tasks, and decisions in place.
4. If spec-kit format: sync `Comment:`, phase checkboxes in `plan.md`, and `docs/backlog.md` when the last phase completes.
5. Do **not** use `spec-kit` during execution.

## Skills prerequisite

This project expects the `spec-kit` and `task-executor` skills from [kallebelins/my-skills](https://github.com/kallebelins/my-skills) to be installed and available to the agent.
