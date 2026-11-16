---
name: spec-kit-0-architecture
description: "Creates or updates the architecture reference document docs/<module>-architecture.md for one module, based only on evidence read from the codebase and answers from the user. Used by the spec-kit orchestrator when no architecture reference exists. WHEN: architecture document missing, create architecture reference, document module architecture, spec-kit Step 2 found no *architecture*.md. DO NOT USE FOR: writing spec.md/plan.md/tasks.md, changing application code, proposing a new architecture not present in the code."
argument-hint: "Module to document (folder path or name) and, optionally, the target file name"
---

# Spec-Kit Sub-Skill 0 — Architecture Reference

## Purpose

Produce `docs/<module>-architecture.md`: a factual description of how a module is built today (stack, layers, folder layout, naming, cross-cutting concerns, testing). Every later spec-kit file grounds its architecture/implementation detail in this document, so it must describe what exists — not what would be ideal.

## When to Use

- `spec-kit` Step 2 found no applicable `*architecture*.md` under `docs/`.
- The user explicitly asks to document a module's architecture.
- An existing architecture document is outdated and the user asks to refresh it.

## When Not to Use

- Writing spec/plan/tasks files.
- Designing a new architecture for a module that does not exist yet → ask the user to describe the target pattern instead and record it as `agreed with the user`.

## Inputs

| Input | Required | Source | If missing |
|---|---|---|---|
| Module path | Yes | User or `spec-kit` | List top-level folders with a build manifest (`package.json`, `pom.xml`, `build.gradle*`, `*.csproj`, `go.mod`, `pyproject.toml`) and ask which one. |
| Target file name | No | User | Use `docs/<module-short-name>-architecture.md` (e.g. `backend`, `frontend`). Ask if ambiguous. |

## Preconditions

- [ ] The module folder exists and contains a build manifest.
- [ ] The target file does not exist, or the user confirmed it may be updated.

## Procedure

1. Read the module's build manifest. Record language, framework, framework version, build tool and main libraries (only those declared).
2. List the source tree two to three levels deep. Record the top-level layering (e.g. `domain/` + `infrastructure/`, `core/` + `features/` + `shared/`).
3. Open at least one representative file per layer. Record the patterns actually used (e.g. records vs classes, standalone components, mapper style, DI style).
4. Search for cross-cutting artifacts and record their path and role when found: authentication/authorization, error handling, response wrapper, logging/tracing, configuration, persistence/migrations, HTTP interceptors, routing.
5. Inspect existing tests. Record frameworks, location conventions and test naming.
6. Derive naming conventions only from at least two consistent examples in code. If examples conflict → record both and ask the user which is canonical.
7. List every question the code could not answer. Ask the user. Do not continue until answered or the user says to mark them `TBD`.
8. Write the document using the structure in **Output**.
9. Hand back to `spec-kit` with the file path.

## Rules

### MUST

- Cite at least one repository path as evidence for each convention.
- Mark anything not confirmed by code or by the user as `TBD`.
- Keep the document descriptive (what is), not prescriptive (what should be), unless the user dictates a rule.

### MUST NOT

- Invent layers, libraries, patterns, paths or naming rules not observed in the code.
- Modify application code.
- Copy conventions from another module or project without the user's confirmation.

## Handoff

| Direction | Skill | Data |
|---|---|---|
| Called by | [spec-kit](../spec-kit/SKILL.md) (Step 2) | Module to document |
| Returns to | [spec-kit](../spec-kit/SKILL.md) (Step 3) | Path of the written document |

## Output

File `docs/<module>-architecture.md` with these sections, in order:

1. `# Architecture — <Module>`
2. `## Stack` — language, framework + version, build tool, main libraries (table).
3. `## Folder Structure` — tree + the role of each folder in one line.
4. `## Layers and Dependency Direction` — allowed and forbidden dependencies.
5. `## Naming Conventions` — table: Artifact | Pattern | Example path.
6. `## Cross-Cutting Concerns` — security, errors, responses, logging/tracing, configuration, persistence/migrations (each with a path).
7. `## Testing` — frameworks, location, naming, coverage rules, if any.
8. `## How to Add a Feature` — ordered steps derived from the previous sections.
9. `## Open Points (TBD)` — unanswered items.

Output language: English. Keep code identifiers and paths unchanged.

## Done Criteria

- [ ] All 9 sections exist.
- [ ] Every convention cites at least one existing path.
- [ ] No convention is unsupported by code or by an explicit user answer.
- [ ] Open questions were asked; remaining ones are listed as `TBD`.
- [ ] Path returned to `spec-kit`.
