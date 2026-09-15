# Spec-Driven Workflow

Classify every request as **planning** or **execution**. Do not mix them in one pass.

Skills from [kallebelins/my-skills](https://github.com/kallebelins/my-skills) should be installed (e.g. under `.claude/skills/` or via your skill manager). Read the matching `SKILL.md` before acting.

## Planning → `spec-kit`

Triggers: plan a feature, write a spec, `/spec`, decompose before coding.

1. If `docs/architecture.md` is missing, run `spec-kit-architecture` first (or suggest it).
2. Follow the `spec-kit` skill — do **not** write application code.
3. Produce in order: `spec.md` → `plan.md` → `tasks.md` under `docs/specs/feature-{NNN}/`, then register in `docs/backlog.md`.

## Execution → `task-executor-m24h`

Triggers: implement a task, mark done, execute an item from `tasks.md` / backlog.

1. Follow the `task-executor-m24h` skill.
2. Route via `skill-router` before implementation (Mvp24Hours catalog).
3. Implement only registered tasks; if the work is not in the task structure, ask before proceeding.
4. When done: mark `[x]`, record status, pending sub-tasks, and decisions in place.
5. If spec-kit format: sync `Comment:`, phase checkboxes in `plan.md`, and `docs/backlog.md` when the last phase completes.
6. Do **not** use `spec-kit` during execution.
