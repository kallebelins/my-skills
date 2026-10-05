---
doc: migration-architecture
project: {{project name}}
status: draft
version: 1.0.0
generated_by: migration-backlog-m24h
verified_at: {{YYYY-MM-DD}}
source_framework: {{net48 | netcoreapp3.1 | net6.0 | net8.0 | net9.0 | mixed | unknown}}
target_framework: net10.0
strategy: {{parallel | in-place | strangler-by-module}}
contract_policy: {{parity | controlled-changes}}
mvp24hours_version: {{version reported by the MCP}}
mvp24hours_template: {{template id from resolve_architecture, e.g. simple-nlayers}}
backlog_ref: docs/migration/backlog.md
last_amended: {{YYYY-MM-DD}}
---

# Migration Architecture — {{Project Name}}

<!-- Planning document for the migration to .NET 10 with Mvp24Hours.
     Facts come from files read in the repository or from mvp24hours MCP results.
     Unknown = `unknown`. Unverified library API = `unverified`. Never include secret values. -->

## 1. Migration Profile

| Field | Value |
|---|---|
| Repository type | {{monolith | multi-service | library | worker | full-stack | unknown}} |
| Current framework(s) | {{from csproj}} |
| Target framework | net10.0 |
| Strategy | {{parallel (default) | in-place | strangler-by-module}} — {{one-line rationale}} |
| API contract policy | {{parity (default) | controlled-changes}} — {{decision source: default | user, date}} |
| Scope | {{solutions/projects in scope}} |
| Out of scope | Secrets handling (see D-001), {{others}} |
| Build | {{command or unknown}} |
| Test | {{command or unknown}} |
| CI | {{file path or unknown}} |
| Baseline (pre-migration) | Build: {{ok | failed | unknown}}; warnings: {{N | unknown}}; tests: {{passed/failed/skipped | unknown}} |

## 2. Migration Principles

<!-- MUST = binding for every backlog item. -->

1. **MCP-verified.** Every Mvp24Hours API used in the backlog MUST be verified through the MCP (`find_source_symbol` / `verify_doc_claim`).
2. **Configuration preserved.** Existing keys, sections, environment-variable names, and values MUST NOT change. New settings are additive.
3. **No secrets work.** This migration MUST NOT introduce secret stores or rotation (D-001).
4. **Test-backed.** Every migrated item MUST have tests; replacements MUST have a characterization test on the legacy behavior first.
5. **No dual implementations.** Legacy and Mvp24Hours implementations MUST NOT be registered together for the same service.
6. **Observable end to end.** Every layer MUST emit logs, traces, and metrics per section 8.
7. **Incremental and reversible.** Each backlog item MUST be independently mergeable with a documented rollback.
8. **Contract parity.** The public API contract MUST stay identical to the legacy one; any change is a separate, approved, versioned item (section 6).
9. **Side by side.** With the `parallel` strategy, the legacy application MUST remain untouched and deployable until the observation window after cutover ends.
10. {{Additional project-specific principle, or remove}}

## 3. Current State Inventory

### 3.1 Projects

| Project | Path | Type | Target framework | SDK-style | Notes |
|---|---|---|---|---|---|
| {{name}} | {{path}} | {{api | lib | worker | test}} | {{tfm}} | {{yes | no}} | {{...}} |

### 3.2 Packages of interest

| Package | Version | Used by | Note |
|---|---|---|---|
| {{e.g. MediatR, AutoMapper, Swashbuckle, Polly, Mvp24Hours.*}} | {{v}} | {{project}} | {{replace | keep | upgrade}} |

### 3.3 Entry points and hosting

- {{Startup.cs / Program.cs / web.config / worker hosts, with file paths}}

### 3.4 Local implementations

| ID | Local implementation | Path(s) | Purpose | Test coverage today |
|---|---|---|---|---|
| INV-01 | {{e.g. custom cache wrapper}} | {{path}} | {{...}} | {{none | partial | good | unknown}} |

### 3.5 Observability today

- Logging: {{framework, sinks}}
- Tracing/metrics: {{none | ...}}
- Correlation ids: {{...}}
- Health endpoints: {{...}}

## 4. Target Architecture

### 4.1 Overview

{{One paragraph: chosen Mvp24Hours template, why it fits (from resolve_architecture), and whether the current layout is preserved or restructured, with the recorded user decision.}}

### 4.2 Layers

<!-- From list_layers / get_architecture_template. -->

| Layer | Responsibility | Depends on | Current paths | Target paths |
|---|---|---|---|---|
| {{name}} | {{...}} | {{...}} | {{...}} | {{...}} |

### 4.3 Dependency rules

- WebAPI/Worker → Application → Core/Domain; Infrastructure → Core/Domain only.
- Infrastructure is composed at the host and is not referenced by Application.
- {{Project-specific rules or violations found today}}

### 4.4 Target project structure

```text
{{output of suggest_project_structure, adjusted to the chosen layout}}
```

### 4.5 Composition root (`Program.cs`)

{{Registration order and extension methods, based on get_di_registration_hints. List only verified symbols.}}

## 5. Replacement Map

<!-- One row per INV-NN. Decision: Replace | Adopt | Keep | Remove | Decide. -->

| INV | Decision | Mvp24Hours / native target | Package | Verified by | Behavior differences to test | Backlog |
|---|---|---|---|---|---|---|
| INV-01 | {{Replace}} | {{symbol or API}} | {{package}} | {{find_source_symbol: X / doc path}} | {{e.g. time zone, expiration}} | {{MIG-3.1}} |

### Applicable breaking and behavior changes

<!-- From package-9-to-10, legacy-to-native-apis, migration.md. List only those that apply. -->

| Change | Applies because | Backlog |
|---|---|---|
| {{e.g. TelemetryHelper removed}} | {{evidence}} | {{MIG-x.y}} |

## 6. Strategy and API Contract Parity

### 6.1 Strategy

| Aspect | Decision |
|---|---|
| Deployment topology | {{legacy and new run side by side; where each lives (folder/solution/branch/host)}} |
| Traffic routing | {{gateway / load balancer / DNS / existing mechanism; or unknown}} |
| Cutover | {{gradual (percentage / internal users first) | all at once}} — {{criteria to proceed}} |
| Rollback | {{routing change back to legacy}} |
| Observation window | {{duration}}, then decommission the legacy application (final backlog item) |

### 6.2 Contract baseline (frozen before building)

| Source | Location | Status |
|---|---|---|
| OpenAPI/Swagger of the legacy API | {{path or URL | not available}} | {{captured | to capture}} |
| Route/verb/status inventory | {{section 6.3 | path}} | {{...}} |

### 6.3 Contract inventory

| Endpoint | Verb | Request shape | Response shape | Status codes | Auth | Notes (pagination, headers) |
|---|---|---|---|---|---|---|
| {{/api/x}} | {{GET}} | {{...}} | {{...}} | {{200, 404, ...}} | {{...}} | {{...}} |

### 6.4 Risks of silent contract drift

| Area | Legacy behavior | Risk in .NET 10 / Mvp24Hours | Parity test |
|---|---|---|---|
| OpenAPI generation | {{Swashbuckle}} | {{native OpenAPI output differs}} | {{MIG-x.y.T#}} |
| JSON serialization | {{casing, enums, dates, nulls}} | {{System.Text.Json defaults}} | {{...}} |
| Error payloads | {{legacy shape}} | {{ProblemDetails}} | {{...}} |
| Validation | {{messages, status codes}} | {{...}} | {{...}} |
| Routing / model binding / CORS / middleware order | {{...}} | {{...}} | {{...}} |

### 6.5 Parity harness

- Same request suite against legacy and new instances (base URL parameterized).
- Compares status, relevant headers, and JSON shape (semantic diff); volatile fields ignored: {{timestamps, generated ids, ...}}.
- Shadow/replay of real traffic: {{yes | no | unknown}}.
- Backlog: {{MIG-x.y}}

### 6.6 Shared resources during coexistence

| Resource | Shared by both apps? | Coexistence rule | Backlog |
|---|---|---|---|
| Database | {{yes | no}} | Backward-compatible schema changes only (expand, then contract); the new app does not apply migrations before approved cutover | {{...}} |
| Cache / broker | {{...}} | {{...}} | {{...}} |
| Consumers and scheduled jobs | {{...}} | Enabled on one side at a time to avoid double processing | {{...}} |

### 6.7 Approved contract changes

<!-- Empty under `parity`. Each change: endpoint, change, versioning approach, approved by, date, backlog ID. -->

| Change | Versioning | Approved by | Backlog |
|---|---|---|---|
| none | — | — | — |

## 7. Configuration Preservation

### 7.1 Policy

- Keys, sections, environment-variable names, and values MUST stay as they are today.
- Binding moves to `IOptions<T>` with `ValidateOnStart`, using the same section names.
- Any key rename requires explicit user approval recorded here.
- New settings (for example observability) are additive.

### 7.2 Configuration map

<!-- Keys and sections only. NEVER values of credentials. -->

| Source file / env | Section or key | Options class (target) | Status | Parity test |
|---|---|---|---|---|
| {{appsettings.json}} | {{Section:Key}} | {{MyOptions}} | preserved | {{MIG-5.x.T1}} |

### 7.3 Additive settings

| Setting | Purpose | Default | Environments |
|---|---|---|---|
| {{e.g. OTEL_EXPORTER_OTLP_ENDPOINT}} | {{...}} | {{...}} | {{dev | prod}} |

## 8. Observability and Tracing Design

### 8.1 Objectives

- Follow a request end to end across all layers in development.
- Keep partial, cost-aware coverage in production for the critical flows.

### 8.2 Layer coverage

| Layer | Traces | Metrics | Logs | Propagation | Backlog |
|---|---|---|---|---|---|
| Host / API | {{inbound HTTP}} | {{rate, errors, duration}} | {{ILogger + trace id}} | {{W3C traceparent}} | {{MIG-4.x}} |
| Application | {{span per use case}} | {{business counters}} | {{...}} | {{...}} | {{...}} |
| Domain / Core | {{none; events carry context}} | {{...}} | {{...}} | {{...}} | {{...}} |
| Infrastructure | {{DB, cache, HTTP, broker}} | {{...}} | {{...}} | {{...}} | {{...}} |
| Workers / jobs | {{root span per run}} | {{...}} | {{...}} | {{from message headers}} | {{...}} |

### 8.3 Environment profiles

| Profile | Sampling | Detail | Export |
|---|---|---|---|
| Development | 100% | All layers, verbose | {{console / local OTLP collector}} |
| Production | {{parent-based ratio}}; critical flows and errors always sampled | Entry points, critical use cases, external dependencies, errors | {{OTLP endpoint}} |

### 8.4 Critical flows (production)

| Flow | Entry point | Why critical | Status |
|---|---|---|---|
| {{flow}} | {{route / consumer / job}} | {{...}} | {{confirmed | proposed}} |

### 8.5 Conventions

- Span and metric names are stable and low-cardinality: `{{convention}}`.
- No PII, secrets, or payloads in attributes or logs.
- Correlate logs with `TraceId`/`SpanId`.
- Verified Mvp24Hours symbols: {{list from the MCP, e.g. AddOpenTelemetry, ActivitySource}}.

## 9. Testing Strategy

### 9.1 Stack

| Concern | Choice | Source |
|---|---|---|
| Framework | {{existing, e.g. xUnit}} | {{existing project | get_test_scaffold}} |
| Integration host | `WebApplicationFactory<Program>` | compliance checklist |
| Persistence in tests | {{EF InMemory in Testing env | Testcontainers}} | {{...}} |
| Time | `FakeTimeProvider` | migration guide |
| Observability assertions | In-memory exporters | this document |

### 9.2 Rules

- Characterization tests on legacy behavior are written and green before an item is replaced (Phase 0).
- Every migrated item has unit and/or integration tests, as defined in its backlog entry.
- Behavior differences in section 5 have explicit tests.
- Naming `Method_Scenario_Expected`; traits `Unit` / `Integration`; Docker-dependent tests skip when Docker is unavailable.

### 9.3 Test projects

| Test project | Covers | Status |
|---|---|---|
| {{name}} | {{area}} | {{existing | to create}} |

## 10. Sequencing and Rollout

- Waves: {{summary of phases 0–7 and the item order rationale}}
- Branching and merge policy: {{one PR per backlog item | per phase}}
- Rollback: {{keep previous artifact; revert item PR; no dual registration}}
- Environments and validation order: {{dev → staging → prod}}

## 11. Quality Gates

A backlog item is **done** only when:

- [ ] Legacy code removed from the new application; no dual registration (with `parallel`, the legacy application itself stays untouched until decommission).
- [ ] Contract parity harness passes for the affected endpoints (no unapproved differences).
- [ ] Item tests (and the characterization test) pass.
- [ ] `dotnet build -c Release /p:TreatWarningsAsErrors=true` succeeds.
- [ ] `dotnet list package --vulnerable --include-transitive` has no new findings.
- [ ] `run_compliance_check` on the touched paths is clean, except deviations in section 13.
- [ ] Observability signals verified where the item applies.
- [ ] Backlog item updated in place (checkbox, Comment, decisions).

## 12. Risks and Open Questions

### Risks

| ID | Risk | Impact | Mitigation | Backlog |
|---|---|---|---|---|
| R-01 | {{...}} | {{...}} | {{...}} | {{...}} |

### Open questions

| ID | Question | Needed for | Owner | Status |
|---|---|---|---|---|
| Q-01 | {{...}} | {{...}} | {{...}} | open |

## 13. Documented Deviations

| ID | Deviation | Rule it departs from | Reason | Accepted by | Risk |
|---|---|---|---|---|---|
| D-001 | No secrets handling in this migration | Compliance checklist: secrets from env vars, user secrets, or a secret store | Project decision: current configuration stays as is | {{user, date}} | Credentials in configuration stay as they are today; out of scope |

## 14. References

| Source | Reference |
|---|---|
| MCP | {{tool + argument, e.g. resolve_architecture(situation=...)}} |
| Library docs | {{e.g. migration.md, modernization/migration-guide.md, observability/home.md}} |
| Repository | {{paths}} |

---

**Version:** {{version}} | **Verified:** {{verified_at}} | **Last Amended:** {{last_amended}}
