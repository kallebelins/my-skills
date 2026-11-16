# My Skills

Repository for sharing reusable skills for agents and development assistants. The goal is to centralize patterns, documentation, and conventions so new skills can be created, reviewed, and reused consistently.

> **Languages:** This is the default (English) README. For Portuguese, see [README.pt.md](README.pt.md).

## Purpose

- Group skills focused on automation, planning, and task execution.
- Standardize skill structure and documentation.
- Make collaboration easier for people who want to create or evolve skills.
- Keep each skill simple, reusable, and easy to understand.

## Repository Structure

```text
my-skills/
├── README.md
├── README.pt.md
├── spec-kit/
│   ├── spec-kit/
│   │   ├── SKILL.md
│   │   └── templates/
│   │       ├── backlog.template.md
│   │       ├── plan.template.md
│   │       ├── spec.template.md
│   │       └── tasks.template.md
│   ├── spec-kit-0-architecture/
│   ├── spec-kit-1-specify/
│   ├── spec-kit-2-plan/
│   ├── spec-kit-3-tasks/
│   ├── spec-kit-4-backlog/
│   └── spec-kit-executor/
├── executor/
│   ├── task-executor/
│   ├── task-executor-m24h/
│   └── task-executor-architect/
├── git/
│   └── git-sync-develop/
├── migration/
│   └── migration-backlog-m24h/
│       ├── SKILL.md
│       └── templates/
│           ├── migration-architecture.template.md
│           └── migration-backlog.template.md
├── qa/
│   ├── qa-bug-analysis/
│   ├── qa-java-unit-tests/
│   └── qa-sonar-quality-gate/
├── thinking/
│   └── req-discovery-refinement/
├── presets/
│   ├── cursor/{task-executor,task-executor-m24h,task-executor-architect}/
│   ├── vscode/{task-executor,task-executor-m24h,task-executor-architect}/
│   ├── claude-code/{task-executor,task-executor-m24h,task-executor-architect}/
│   └── kiro/{task-executor,task-executor-m24h,task-executor-architect}/
└── ...other-skills/
    └── SKILL.md
```

## Skill Catalog

| Skill | Folder | What it does |
|---|---|---|
| `spec-kit` | `spec-kit/spec-kit` | Orchestrates feature planning: resolves the feature folder and architecture reference, then runs the sub-skills in order to produce `spec.md`, `plan.md`, `tasks.md` and a backlog entry. |
| `spec-kit-0-architecture` | `spec-kit/spec-kit-0-architecture` | Documents a module's architecture (`docs/<module>-architecture.md`) from evidence found in the code. |
| `spec-kit-1-specify` … `spec-kit-4-backlog` | `spec-kit/` | Sub-skills that write `spec.md`, `plan.md`, `tasks.md` and maintain `docs/backlog.md` (called by `spec-kit`). |
| `spec-kit-executor` | `spec-kit/spec-kit-executor` | Executes one registered task (or bug fix plan item), updates the task artifact in place and records the completion in the CHANGELOG. |
| `task-executor` | `executor/task-executor` | Generic task executor: implements registered tasks and updates them in place. |
| `task-executor-architect` | `executor/task-executor-architect` | Task executor that first selects and follows an architect skill when the task involves architectural decisions. |
| `task-executor-m24h` | `executor/task-executor-m24h` | Task executor with automatic specialist routing (`skill-router`) for Mvp24Hours projects. |
| `migration-backlog-m24h` | `migration/migration-backlog-m24h` | Plans a .NET 10 migration with Mvp24Hours: architecture document and test-backed backlog (planning only). |
| `qa-bug-analysis` | `qa/qa-bug-analysis` | Investigates a bug without changing code and writes `docs/bugs/bug-NNN-*.md` with root cause, evidence and a fix plan. |
| `qa-java-unit-tests` | `qa/qa-java-unit-tests` | Creates or reviews Java unit tests (JUnit 5 + Mockito) with at least 80% coverage per changed class. |
| `qa-sonar-quality-gate` | `qa/qa-sonar-quality-gate` | Fixes SonarQube issues from a project link until the Quality Gate passes. |
| `git-sync-develop` | `git/git-sync-develop` | Safely merges the base branch (default `develop`) into the current branch, validates, pushes and offers a pull request. |
| `req-discovery-refinement` | `thinking/req-discovery-refinement` | Turns a brainstorm into a requirements refinement document grounded in project evidence and verified references. |

Typical flow: `req-discovery-refinement` → `spec-kit` → `spec-kit-executor` (or a `task-executor` variant). For bugs: `qa-bug-analysis` → `spec-kit-executor`.

> **Language:** skills, templates and the documents they generate are in English. Only the `README.pt.md` files are in Portuguese.

## Project Bootstrap (Presets)

To wire a consumer project so the agent always uses **spec-kit** for planning and a **task-executor** variant for execution, copy a preset from [`presets/`](presets/).

1. Choose the tool: `cursor`, `vscode`, `claude-code`, or `kiro`.
2. Choose the executor: `task-executor`, `task-executor-m24h`, or `task-executor-architect`.
3. Copy the contents of `presets/<tool>/<executor>/` into the target project root.
4. Install the matching skills from `spec-kit/` and `executor/`.

Full install guide: [presets/README.md](presets/README.md).

## Collaboration Standard

Every skill must follow a simple, predictable structure. This makes skills easier to read, maintain, and use across different contexts.

### 1. Folder Name

Use a short, descriptive, lowercase name, preferably with hyphens when needed.

Examples:

- spec-kit
- spec-kit-0-architecture
- spec-kit-2-plan
- qa-bug-analysis
- git-sync-develop

### 2. Main File

Each skill must contain a file named `SKILL.md` at the root of its folder.

The file must follow this minimum pattern:

```yaml
---
name: skill-name
created by: Your Name
description: "Describe when the skill should be used and what problem it solves."
argument-hint: "Example input for using the skill"
---
```

### 3. Recommended Content Structure

Each `SKILL.md` must include, at minimum:

- `## Purpose`
- `## When to Use`
- `## Procedure`
- `## Output`
- `## Verification` (or `## Done Criteria`)

This pattern makes the skill easy to understand for both humans and agents.

## Quality Guidelines

When creating or updating a skill, follow these rules:

- Keep the skill focused on a specific goal.
- Avoid coupling to specific technologies when the solution can be generic.
- Prefer clear, observable instructions.
- Write real-world usage scenarios.
- Use direct, objective language.
- Avoid vague placeholders or ambiguous instructions.
- Document dependencies, expected outputs, and validation criteria.
- Ensure the skill can be reused in different contexts.
- Write skills, templates and generated documents in English (only `README.pt.md` files are in Portuguese).
- Do not reference specific projects, repositories, internal skill names, environments, people or absolute/full folder paths. Use generic placeholders (`<module>`, `<project>`) and paths relative to the repository root.
- Reference other skills only when they exist in this repository, or describe the capability generically (for example, "the project's task tracker").

## Documentation Conventions

- Be careful with consistent naming.
- Use practical examples in `argument-hint` and usage text.
- When a skill orchestrates other skills, make the execution order explicit.
- For the spec-kit workflow, run `spec-kit-0-architecture` first to create `docs/<module>-architecture.md` when the project has no architecture reference yet — then use `spec-kit` to plan features.
- If generated files exist, state exactly which folder or output pattern must be used.
- Keep documentation aligned with the skill's actual behavior.

## Contribution Flow

1. Create a branch for your change.
2. Create or edit the skill folder.
3. Update `SKILL.md` with the standard structure.
4. Document when to use it, how to use it, and what result to expect.
5. Validate that the skill is consistent with the rest of the repository.
6. Open a pull request with a clear description of the goal and impact.

## Pre-Submission Checklist

- [ ] The skill folder has an appropriate name.
- [ ] The `SKILL.md` file exists and is in the correct format.
- [ ] The `description` clearly explains the skill's purpose.
- [ ] The `argument-hint` shows a useful example.
- [ ] Content is organized in clear sections.
- [ ] The skill does not rely on hidden assumptions.
- [ ] Documentation is consistent with the skill's actual intent.

## Example of a Well-Structured Skill

```md
---
name: example-skill
created by: Your Name
description: "Use when you need to automate a repetitive planning task."
argument-hint: "I want to plan a user registration feature"
---

# Example Skill

## Purpose

Automate the creation of an initial plan for a feature.

## When to Use

- When the request involves planning before implementation.
- When a execution checklist needs to be generated.

## Procedure

1. Understand the goal.
2. Identify scope.
3. Break down into steps.
4. Produce an objective proposal.

## Output

A checklist-style plan with sequential steps.

## Verification

- Verify that scope was understood.
- Confirm that steps are in logical order.
```

## Final Best Practice

This repository works best when each skill is:

- small and specialized;
- clear in its purpose;
- easy to review;
- reusable across multiple contexts;
- documented without ambiguity.

When a skill is well written, it becomes easier to share, evolve, and apply in real workflows.

## Contributing

Contributions are welcome. The important thing is to maintain the organization and clarity standard so the repository remains useful and consistent for the whole team.
