---
doc: architecture
project: {{project name}}
status: draft
version: 1.0.0
mode: {{brownfield | greenfield | amend}}
generated_by: spec-kit-architecture
verified_at: {{YYYY-MM-DD}}
architecture_ref: docs/architecture.md
ratified: {{YYYY-MM-DD or TODO}}
last_amended: {{YYYY-MM-DD}}
---

# Architecture & Governance — {{Project Name}}

<!-- Durable project architecture, governance principles, and development guidelines.
     Feature-specific business rules and contracts belong in docs/specs/feature-*/spec.md.
     Per-task implementation detail belongs in tasks.md (Architecture/Implementation field). -->

## Project Profile

| Field | Value |
|---|---|
| Repository type | {{monolith | multi-service | library | frontend | full-stack | unknown}} |
| Primary stack | {{languages, frameworks, runtimes — from discovery or user input}} |
| Entry points | {{main apps, hosts, CLIs — with file paths when brownfield}} |
| Build | {{command or unknown}} |
| Test | {{command or unknown}} |
| Lint / format | {{command or unknown}} |

## System Architecture

### Overview

{{One paragraph describing how the system is structured — layers, modules, or bounded areas.}}

### Layers / Modules

| Layer / Module | Responsibility | Depends on | Example paths |
|---|---|---|---|
| {{name}} | {{...}} | {{...}} | {{verified paths or (greenfield target)}} |

### Dependency Rules

- {{Allowed dependency direction, e.g. "UI → application → domain; infrastructure implements domain ports"}}
- {{Forbidden couplings observed or declared}}

<!-- Optional ASCII diagram when it clarifies boundaries -->
<!--
┌─────────┐     ┌──────────────┐     ┌────────────┐
│  {{UI}} │ --> │ {{App/Core}} │ --> │ {{Infra}}  │
└─────────┘     └──────────────┘     └────────────┘
-->

## Core Principles

<!-- 5–9 non-negotiable principles. Use MUST for binding rules, SHOULD for strong guidance.
     Derive from observed code (brownfield) or agreed pattern (greenfield).
     Mark proposed items until the user confirms. -->

### I. {{Principle Name}}

- **Rules:** {{MUST/SHOULD statements — declarative and testable}}
- **Rationale:** {{why this principle exists}}
- **Evidence:** {{file paths or doc refs in brownfield; "agreed pattern" in greenfield}}

### II. {{Principle Name}}

- **Rules:** {{...}}
- **Rationale:** {{...}}
- **Evidence:** {{...}}

<!-- Add III–IX as needed -->

## Development Guidelines

<!-- Concrete conventions that spec-kit-tasks will cite in Architecture/Implementation fields. -->

### Project Layout

- {{Where new features, modules, tests, and config live — with paths}}

### Naming

- {{Files, types, endpoints, components, tests}}

### Testing

- {{Test types expected, location, naming, minimum coverage expectations if any}}

### Error Handling

- {{How errors surface — HTTP codes, user messages, logging}}

### API / Integration Conventions

- {{Only when applicable — versioning, auth, serialization, idempotency}}

### Commits / PRs

- {{Branch naming, review expectations — if established}}

## Documentation Boundaries

| Topic | Document here (`architecture.md`) | In `spec.md` | In `tasks.md` |
|---|---|---|---|
| Layering & module boundaries | Yes | No | Reference only |
| Cross-cutting conventions (naming, tests, errors) | Yes | No | Apply per task |
| Governance principles (MUST/SHOULD) | Yes | No | Apply per task |
| Business rules | No | Yes | Implement per task |
| Feature contracts / schemas | No | Yes | Implement per task |
| Acceptance criteria | No | Yes | Trace per task |
| One-action implementation steps | No | No | Yes |

## Governance

### Amendment Process

1. Propose changes in a PR that updates `docs/architecture.md` only (or with related ADRs).
2. Bump `version` in frontmatter using semantic versioning:
   - **MAJOR:** backward-incompatible principle removal or redefinition
   - **MINOR:** new principle or materially expanded guidance
   - **PATCH:** clarifications, wording, non-semantic refinements
3. Set `last_amended` to the merge date; keep `ratified` as the original adoption date.
4. Re-run brownfield discovery when code structure diverges materially from this document.

### Compliance Review

- Before merging feature work, verify tasks follow principles and guidelines listed here.
- During `spec-kit` planning, `tasks.md` MUST ground Architecture/Implementation fields in this file.
- Feature specs MUST NOT contradict a MUST principle without an explicit amendment here first.

## References

- {{Optional — docs/{stack}/ guides, ADRs, README sections, external pattern docs}}

---

**Version:** {{version}} | **Ratified:** {{ratified}} | **Last Amended:** {{last_amended}}
