---
name: spec-kit-architecture
created by: Kallebe Lins | gh:kallebelins/my-skills
description: "Creates or updates docs/architecture.md — the project's durable architecture reference with governance principles and development guidelines (speckit-constitution style). Supports brownfield code discovery, greenfield pattern definition, and amend/refresh modes. Stack-agnostic. Use when docs/architecture.md is missing, stale, or before the first spec-kit run; when onboarding a repo to spec-driven development; or when the user asks to document project architecture and conventions."
argument-hint: "Mode (brownfield | greenfield | amend) and optional scope or reference guide path — e.g. 'Brownfield discovery for this repo' or 'Greenfield architecture for a new API using docs/dotnet/'"
---

# Spec-Kit Architecture

## Purpose

Produce or update `docs/architecture.md` at the target project's `docs/` root — the single source of truth that `spec-kit` reads in Step 2 and that `spec-kit-tasks` grounds in every task's **Architecture/Implementation** field.

The document combines:

- **Observed or declared system architecture** (layers, modules, boundaries)
- **Core principles** — non-negotiable governance rules (MUST/SHOULD), in the spirit of [speckit-constitution](https://github.com/github/spec-kit/blob/main/templates/constitution-template.md)
- **Development guidelines** — concrete conventions agents need when implementing tasks
- **Documentation boundaries** — what belongs here vs in feature `spec.md` vs `tasks.md`
- **Governance** — semver, amendment process, compliance expectations

This skill is **stack-agnostic**. Never hardcode `angular`, `dotnet`, or `quarkus` — resolve stack and patterns from the repository or from explicit user input at runtime.

## When to Use

- `docs/architecture.md` does not exist and the project wants a durable reference before running `spec-kit`
- An existing `docs/architecture.md` is outdated after structural changes
- Brownfield onboarding: discover architecture and conventions from code already in the repo
- Greenfield setup: define architecture and principles for a new project before the first feature spec
- The user asks to create, refresh, or amend project architecture / constitution / development guidelines

**Not for:**

- Writing feature specs (`spec-kit`, `spec-kit-spec`)
- Inventoring product features for the backlog (`spec-kit-backlog` Mode C/D)
- Implementing code or tasks (`spec-kit-tasks` execution protocol)

## Scope Guard

This skill's work is limited to `docs/architecture.md` (and creating `docs/` if missing).

- Do **not** create or modify `spec.md`, `plan.md`, `tasks.md`, or `docs/backlog.md`
- Do **not** implement application source, tests, CI, or deployment artifacts
- If the user input mixes architecture work with feature implementation, extract the implementation intent as a deferred follow-up and suggest `spec-kit` afterward — do not execute it here

## Inputs

| Input | Required | Notes |
|---|---|---|
| Target repository root | **Yes** | Where `docs/architecture.md` will live |
| Mode | No | Auto-detect when omitted (see *Mode Selection* below) |
| Scope (subfolder / service) | No | For large monorepos — default: repository root |
| Reference guide path | No | e.g. `docs/{stack}/` the user wants incorporated (greenfield or amend) |
| User-stated principles / constraints | No | Organizational rules to merge into Core Principles |

## Template

Use `spec-kit/templates/architecture.template.md` as the exact structure and frontmatter to fill in.

## Mode Selection

When the user does not specify a mode:

1. If `docs/architecture.md` **exists** → **Mode C — Amend** (unless the user explicitly asks for a full rewrite)
2. Else if the repository has **meaningful code** in scope → **Mode A — Brownfield**
3. Else → **Mode B — Greenfield**

Meaningful code: at least one source file outside `node_modules`, `bin`, `obj`, `dist`, `vendor`, `.git`, and build output.

## Procedure

### Step 1 — Preflight

1. Confirm the repository root exists; resolve scope if given.
2. Ensure `docs/` exists (create the directory if needed — only `docs/`, not other folders).
3. Check whether `docs/architecture.md` already exists.
4. Record header facts for the document: project name (from README, manifest, or user), `verified_at` (today's date), git branch/commit when available.

### Step 2 — Execute the Selected Mode

#### Mode A — Brownfield (discovery)

For repositories with existing code.

1. **Inventory** (verified evidence only — never invent):
   - Manifests: `package.json`, `*.csproj`, `pom.xml`, `build.gradle`, `go.mod`, `Cargo.toml`, `pyproject.toml`, etc.
   - Folder structure and entry points (hosts, CLIs, main apps)
   - Sample patterns from representative files: handlers/controllers, services/use cases, repositories, UI components, tests
   - Build/test/lint commands from manifests, Makefile, CI config — or mark `unknown`
   - Existing docs (`README`, `docs/`, ADRs) as **secondary** sources — **code wins** on any divergence
2. **Draft architecture sections** from what was observed: Project Profile, System Architecture, Development Guidelines.
3. **Derive Core Principles** from observed patterns and explicit rules in existing docs. Where there is no evidence, mark the principle as `proposed` and ask the user before writing it as MUST.
4. **Present the draft** to the user for confirmation before writing — unless the user explicitly asked for direct generation without review.

#### Mode B — Greenfield (definition)

For new projects or scopes with no meaningful code.

1. If stack, pattern, or constraints are unclear, ask targeted questions — do not assume a stack.
2. If the user points to a reference guide (e.g. `docs/{stack}/`), read it and incorporate — still do not default to a specific stack without input.
3. Propose Project Profile, System Architecture, Core Principles, and Development Guidelines aligned with the chosen pattern.
4. Mark unresolved sections as `proposed` or `TODO(field): explanation`.
5. **Present the draft** to the user for confirmation before writing.

#### Mode C — Amend (update)

When `docs/architecture.md` already exists.

1. Read the current document; preserve principles and guidelines still applicable.
2. Apply user-requested changes or re-run partial brownfield discovery when the user asks for a refresh or code structure changed materially.
3. Bump `version` in frontmatter per semantic versioning:
   - **MAJOR:** backward-incompatible principle removal or redefinition
   - **MINOR:** new principle or materially expanded guidance
   - **PATCH:** clarifications, wording, non-semantic refinements
4. Update `last_amended` to today; keep `ratified` unless this is the first ratification.
5. Add a temporary HTML comment **Sync Impact Report** at the top of the file (before frontmatter is invalid — place it as the first line inside the file after write, or immediately after frontmatter as an HTML comment block):
   - Version change: old → new
   - Modified, added, and removed principles/sections
   - Deferred TODOs
   - This report is scratch material for human review — expected to be removed before commit.

### Step 3 — Write the Document

1. Fill every section of the template — no unexplained `{{placeholder}}` tokens remain.
2. Set frontmatter: `status` to `active` when user-confirmed, `draft` when items remain proposed/TODO; `mode` to the mode used; `generated_by: spec-kit-architecture`.
3. Write only to `docs/architecture.md`.

### Step 4 — Handoff

Report to the user:

- Path to `docs/architecture.md`
- Mode used and version (with bump rationale in Mode C)
- Any `proposed` / `TODO` / `unknown` items needing follow-up
- Suggested next step: run [`spec-kit`](../spec-kit/SKILL.md) to plan the first or next feature

## Content Rules

### Core Principles

- Write 5–9 principles unless the user specifies a different count.
- Each principle: short name, MUST/SHOULD rules (declarative, testable), brief rationale, evidence or source.
- Prefer MUST over vague "should" — if a rule is not binding, use SHOULD explicitly.
- Do not embed feature-specific contracts, API schemas, or acceptance criteria — those belong in `spec.md`.

### Development Guidelines

- Be concrete enough that `spec-kit-tasks` can quote folder paths, naming patterns, test locations, and error-handling conventions without inventing them.
- Brownfield: anchor every guideline to verified paths or observed files.
- Greenfield: anchor to the agreed pattern; mark unconfirmed items as `proposed`.

### Documentation Boundaries

- Always include the boundaries table from the template.
- Reinforce: **here** = durable WHAT/MUST; **spec.md** = business rules and feature contracts; **tasks.md** = per-task HOW.

## Output

Create or update `docs/architecture.md` at the root of the target project's `docs/` folder.

## Verification

Before finishing:

- [ ] `docs/architecture.md` exists and frontmatter matches the template
- [ ] No unexplained `{{placeholder}}` tokens remain
- [ ] `mode`, `version`, `verified_at`, and dates are set correctly
- [ ] Core Principles are declarative and testable (MUST/SHOULD — not vague prose)
- [ ] Brownfield: conventions cite verified file paths; gaps marked `unknown` or `proposed`, not fabricated
- [ ] Greenfield: no stack assumed without user input or an explicit reference guide
- [ ] Mode C: version bump is justified; Sync Impact Report present
- [ ] Documentation Boundaries table is complete
- [ ] No spec-kit feature artifacts or application source were created or modified
- [ ] User confirmed the draft (Modes A and B) unless they explicitly waived review
