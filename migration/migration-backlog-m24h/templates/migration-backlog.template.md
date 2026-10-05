---
doc: migration-backlog
project: {{project name}}
generated_by: migration-backlog-m24h
architecture_ref: docs/migration/architecture.md
last_updated: {{YYYY-MM-DD}}
---

# Migration Backlog — {{Project Name}}

<!-- Executable backlog for the migration to .NET 10 with Mvp24Hours.
     Checkbox format is compatible with task-executor-m24h: [ ] pending, [~] in progress/partial, [x] done.
     IDs are stable: never renumber. New items get new IDs.
     Every item that moves code MUST have test sub-tasks. -->

## How to use

1. Work phases in order; inside a phase, respect `Depends on`.
2. Each item is one independently mergeable change.
3. An item is done only when its Definition of Done (architecture.md section 11) is met and all its test sub-tasks are `[x]`.
4. Update the item in place: checkbox, `Comment:`, pending sub-tasks, and decisions.

## Summary

Strategy: {{parallel | in-place | strangler-by-module}} | Contract policy: {{parity | controlled-changes}}

| Phase | Items | Test tasks |
|---|---|---|
| 0 — Baseline & safety net | {{n}} | {{n}} |
| 1 — Toolchain & target framework | {{n}} | {{n}} |
| 2 — Mvp24Hours adoption | {{n}} | {{n}} |
| 3 — Replace local implementations | {{n}} | {{n}} |
| 4 — Observability & tracing | {{n}} | {{n}} |
| 5 — Configuration parity | {{n}} | {{n}} |
| 6 — Hardening & compliance | {{n}} | {{n}} |
| 7 — Rollout | {{n}} | {{n}} |

## Phase 0 — Baseline & safety net

- [ ] **MIG-0.1 — Record build and test baseline**
  - Priority: P0 | Size: S | Risk: Low | Depends on: none
  - Source: whole solution
  - Target: baseline recorded in architecture.md section 1
  - Configuration impact: none
  - Observability: n/a
  - Tests: n/a (records existing results)
  - Acceptance: build warnings count and test results documented; failing tests triaged (fix, skip with reason, or accepted).
  - Comment:

- [ ] **MIG-0.2 — Characterization tests for {{INV-01 name}}**
  - Priority: P0 | Size: {{S|M|L}} | Risk: Low | Depends on: MIG-0.1
  - Source: `{{verified path}}`
  - Target: tests that pin the current behavior of INV-01, green on the legacy code
  - Configuration impact: none
  - Observability: n/a
  - Tests:
    - [ ] MIG-0.2.T1 {{Method_Scenario_Expected}} — {{what behavior is pinned}}
    - [ ] MIG-0.2.T2 {{edge case / failure path}}
  - Acceptance: tests pass on the legacy implementation and will be re-run unchanged in {{MIG-3.x}}.
  - Comment:

<!-- Contract parity (default policy). Omit MIG-0.3/0.4 only when the policy is `controlled-changes` and record why. -->

- [ ] **MIG-0.3 — Capture the legacy API contract baseline**
  - Priority: P0 | Size: {{S|M}} | Risk: Low | Depends on: MIG-0.1
  - Source: `{{OpenAPI/Swagger document | controllers and routes}}`
  - Target: frozen contract artifact (OpenAPI export or inventory in architecture.md section 6.3), including status codes, error payloads, auth, headers, pagination, serialization settings
  - Configuration impact: none
  - Observability: n/a
  - Tests:
    - [ ] MIG-0.3.T1 Baseline reproduces from the running legacy app (document or responses match the stored artifact)
  - Acceptance: every public endpoint appears in the contract inventory.
  - Comment:

- [ ] **MIG-0.4 — Contract parity harness**
  - Priority: P0 | Size: M | Risk: Low | Depends on: MIG-0.3
  - Target: request suite with parameterized base URL that runs against legacy and new instances; semantic JSON diff; agreed volatile fields ignored ({{timestamps, generated ids}})
  - Configuration impact: additive only (base URLs for the harness)
  - Tests:
    - [ ] MIG-0.4.T1 Harness passes legacy vs legacy (proves it is deterministic)
    - [ ] MIG-0.4.T2 Harness fails when a status code, field, or type is deliberately changed
  - Acceptance: one command runs the full parity suite and reports per-endpoint differences.
  - Comment:

## Phase 1 — Toolchain & target framework

- [ ] **MIG-1.1 — Install .NET 10 SDK and pin it**
  - Priority: P0 | Size: S | Risk: Low | Depends on: MIG-0.1
  - Target: `global.json`, CI and dev machines on the .NET 10 SDK
  - Configuration impact: none
  - Tests: solution restores and builds on the new SDK before any TFM change
  - Acceptance: {{...}}
  - Comment:

<!-- Pick ONE variant of MIG-1.2 according to the strategy in architecture.md section 1. -->

- [ ] **MIG-1.2 — Create the parallel .NET 10 solution `{{NewSolution}}`** (strategy `parallel`, default)
  - Priority: P0 | Size: M | Risk: Low | Depends on: MIG-1.1
  - Source: legacy solution stays untouched (`{{path}}`, {{current tfm}})
  - Target: new solution at `{{path}}` with projects per architecture.md section 4.4, `net10.0`, Nullable and ImplicitUsings enabled, same configuration files and keys copied unchanged
  - Configuration impact: none (keys preserved; secrets handling out of scope, D-001)
  - Observability: n/a
  - Tests:
    - [ ] MIG-1.2.T1 New solution builds and its empty host starts with the preserved configuration
    - [ ] MIG-1.2.T2 Legacy solution still builds and its tests still pass (untouched)
  - Acceptance: both solutions build independently; legacy has no diff.
  - Comment:

- [ ] **MIG-1.2 (alternative) — Retarget `{{Project}}` to `net10.0`** (strategy `in-place` only)
  - Priority: P0 | Size: {{S|M|L}} | Risk: {{Low|Med|High}} | Depends on: MIG-1.1
  - Source: `{{csproj path}}` ({{current tfm}})
  - Target: `<TargetFramework>net10.0</TargetFramework>`, Nullable and ImplicitUsings enabled
  - Configuration impact: none (keys preserved)
  - Observability: n/a
  - Tests:
    - [ ] MIG-1.2.T1 Existing test suite passes on net10.0
    - [ ] MIG-1.2.T2 {{Nullable diagnostics reviewed, not globally suppressed}}
  - Acceptance: builds and tests pass; new warnings triaged.
  - Comment:

<!-- Add here, only when the inventory shows them:
     - .NET Framework porting items (System.Web → ASP.NET Core, web.config → appsettings binding with the SAME keys, OWIN removal)
     - Startup.cs → Program.cs
     - Central Package Management -->

## Phase 2 — Mvp24Hours adoption

- [ ] **MIG-2.1 — Add Mvp24Hours packages at one aligned version**
  - Priority: P0 | Size: S | Risk: Med | Depends on: MIG-1.2
  - Target: `{{Mvp24Hours.* packages}}` at `{{version from MCP}}`; no older Mvp24Hours transitive reference
  - Verified by: `{{MCP tool + argument}}`
  - Configuration impact: none
  - Tests:
    - [ ] MIG-2.1.T1 Restore shows a single Mvp24Hours version in the dependency graph
  - Acceptance: {{...}}
  - Comment:

- [ ] **MIG-2.2 — Composition root in `Program.cs`**
  - Priority: P0 | Size: M | Risk: Med | Depends on: MIG-2.1
  - Target: registrations per `get_di_registration_hints` ({{verified symbols}})
  - Configuration impact: none
  - Tests:
    - [ ] MIG-2.2.T1 `WebApplicationFactory<Program>` boots and resolves core services
    - [ ] MIG-2.2.T2 Health endpoint responds
  - Acceptance: host starts with the same configuration as before.
  - Comment:

## Phase 3 — Replace local implementations

<!-- One item per INV-NN with decision Replace or Remove. Order: leaf dependencies and low risk first. -->

- [ ] **MIG-3.1 — Replace {{INV-01 name}} with {{Mvp24Hours target}}**
  - Priority: P1 | Size: {{S|M|L}} | Risk: {{Low|Med|High}} | Depends on: {{MIG-0.2, MIG-2.2}}
  - Inventory: INV-01
  - Source (current): `{{verified path(s)}}`
  - Target (Mvp24Hours): `{{symbol}}` in `{{package}}` — verified by `{{find_source_symbol / verify_doc_claim}}`; doc `{{path}}`
  - Architecture ref: architecture.md section 5
  - Configuration impact: {{none | keys preserved: `Section:Key` → `{{Options}}`}}
  - Behavior differences to cover: {{e.g. time zone, expiration, retry count}}
  - Observability: {{spans/metrics/logs added or verified}}
  - Tests (required):
    - [ ] MIG-3.1.T1 Re-run characterization tests MIG-0.2.T1–T2 unchanged against the new implementation
    - [ ] MIG-3.1.T2 Unit: {{Method_Scenario_Expected}}
    - [ ] MIG-3.1.T3 Integration: {{...}}
    - [ ] MIG-3.1.T4 Behavior difference: {{...}}
    - [ ] MIG-3.1.T5 Contract parity for `{{endpoints affected}}` via the harness (MIG-0.4): status, headers, body shape, error payloads
  - Steps:
    - [ ] MIG-3.1.1 Introduce the Mvp24Hours implementation behind the existing abstraction (if any)
    - [ ] MIG-3.1.2 Switch call sites; remove the legacy registration (no dual registration)
    - [ ] MIG-3.1.3 Delete legacy code and unused packages
  - Acceptance: {{observable criteria}}
  - Rollback: {{revert PR; previous artifact}}
  - Comment:

## Phase 4 — Observability & tracing

- [ ] **MIG-4.1 — OpenTelemetry foundation (logs, traces, metrics)**
  - Priority: P1 | Size: M | Risk: Low | Depends on: MIG-2.2
  - Target: `{{verified symbols, e.g. AddOpenTelemetry, ActivitySource}}`; `ILogger<T>` with trace correlation; exporters via additive `OTEL_*` settings
  - Verified by: `resolve_feature(opentelemetry)` + `{{find_source_symbol}}`
  - Configuration impact: additive only
  - Tests:
    - [ ] MIG-4.1.T1 In-memory exporter receives an inbound HTTP span
    - [ ] MIG-4.1.T2 Logs carry `TraceId`/`SpanId`
  - Acceptance: a request produces a correlated trace and log entries in development.
  - Comment:

- [ ] **MIG-4.2 — Environment profiles (dev full, prod principal flows)**
  - Priority: P1 | Size: M | Risk: Low | Depends on: MIG-4.1
  - Target: dev 100% sampling; prod parent-based ratio with critical flows and errors always sampled (architecture.md section 8)
  - Tests:
    - [ ] MIG-4.2.T1 Dev profile samples everything
    - [ ] MIG-4.2.T2 Prod profile always samples listed critical flows and errors
  - Comment:

- [ ] **MIG-4.3 — Application layer spans per use case**
  - Priority: P1 | Size: {{M|L}} | Risk: Low | Depends on: MIG-4.1
  - Tests:
    - [ ] MIG-4.3.T1 Each use case produces one span with stable name and no payload attributes
  - Comment:

- [ ] **MIG-4.4 — Infrastructure instrumentation (DB, cache, HTTP clients, broker)**
  - Priority: P1 | Size: {{M|L}} | Risk: Low | Depends on: MIG-4.1
  - Tests:
    - [ ] MIG-4.4.T1 {{Each dependency produces child spans under the use-case span}}
    - [ ] MIG-4.4.T2 {{Context propagates through publish/consume}}
  - Comment:

- [ ] **MIG-4.5 — Workers and scheduled jobs tracing**
  - Priority: P2 | Size: M | Risk: Low | Depends on: MIG-4.1
  - Tests:
    - [ ] MIG-4.5.T1 Each execution has a root span and failure/duration metrics
  - Comment:

- [ ] **MIG-4.6 — Critical flow: {{flow name}}**
  - Priority: P1 | Size: S | Risk: Low | Depends on: MIG-4.2, MIG-4.3, MIG-4.4
  - Tests:
    - [ ] MIG-4.6.T1 End-to-end trace spans all layers in development
    - [ ] MIG-4.6.T2 The flow is sampled under the production profile
  - Comment:

## Phase 5 — Configuration parity

- [ ] **MIG-5.1 — Options binding for `{{Section}}` (keys preserved)**
  - Priority: P1 | Size: S | Risk: Low | Depends on: MIG-2.2
  - Source: `{{file}}` keys `{{Section:Key, ...}}` (names only)
  - Target: `{{Options class}}` with `ValidateOnStart`
  - Configuration impact: none — same keys and values
  - Tests:
    - [ ] MIG-5.1.T1 Same configuration input produces the same option values as the legacy read
    - [ ] MIG-5.1.T2 Invalid value fails at startup
  - Comment:

## Phase 6 — Hardening & compliance

- [ ] **MIG-6.1 — Compliance check**
  - Priority: P0 | Size: S | Risk: Low | Depends on: Phase 3
  - Target: `run_compliance_check` clean on all projects, except deviations in architecture.md section 13
  - Tests: findings resolved or recorded as deviations
  - Comment:

- [ ] **MIG-6.2 — Dependency and warning audit**
  - Priority: P0 | Size: S | Risk: Low | Depends on: Phase 3
  - Target: `dotnet list package --vulnerable --include-transitive` clean; `dotnet build -c Release /p:TreatWarningsAsErrors=true` succeeds
  - Comment:

- [ ] **MIG-6.3 — Remove leftovers**
  - Priority: P1 | Size: S | Risk: Low | Depends on: MIG-6.1
  - Target: no legacy helpers, unused packages, dead configuration readers, or dual registrations
  - Tests: full suite passes
  - Comment:

<!-- Add here the applicable breaking/behavior changes from the Mvp24Hours migration guides
     (e.g. time-zone helper, SQL client, SMTP TLS, encryption compatibility, soft delete, Swashbuckle removal),
     each with a behavior test. -->

## Phase 7 — Rollout

- [ ] **MIG-7.0 — Full contract parity run (legacy vs new)**
  - Priority: P0 | Size: M | Risk: Med | Depends on: Phase 3, MIG-4.2
  - Target: harness (MIG-0.4) passes for every endpoint in architecture.md section 6.3; OpenAPI document diff reviewed; approved differences listed in section 6.7
  - Tests:
    - [ ] MIG-7.0.T1 Zero unapproved differences across the full suite
    - [ ] MIG-7.0.T2 {{Shadow/replay of real traffic compared, if available}}
  - Comment:

- [ ] **MIG-7.1 — Environment validation and smoke tests**
  - Priority: P0 | Size: M | Risk: Med | Depends on: MIG-6.1, MIG-6.2
  - Tests:
    - [ ] MIG-7.1.T1 Health, readiness, and liveness pass in each environment
    - [ ] MIG-7.1.T2 Critical flows traced in production profile
    - [ ] MIG-7.1.T3 Integrations in use pass ({{DB, cache, broker, SMTP, ...}})
  - Comment:

- [ ] **MIG-7.2 — Rollback plan verified**
  - Priority: P0 | Size: S | Risk: Low | Depends on: MIG-7.1
  - Target: legacy application stays deployable; rollback is a routing change back to legacy; steps documented and rehearsed
  - Comment:

- [ ] **MIG-7.3 — Coexistence rules for shared resources**
  - Priority: P0 | Size: S | Risk: Med | Depends on: MIG-7.0
  - Target: rules from architecture.md section 6.6 applied (backward-compatible schema only, no migrations by the new app before approved cutover, consumers/jobs active on one side at a time)
  - Tests:
    - [ ] MIG-7.3.T1 Both applications read and write the shared database without errors
    - [ ] MIG-7.3.T2 A message or job is processed by exactly one side
  - Comment:

- [ ] **MIG-7.4 — Gradual cutover**
  - Priority: P0 | Size: M | Risk: High | Depends on: MIG-7.0, MIG-7.2, MIG-7.3
  - Target: traffic moves in steps ({{internal users | X% | Y% | 100%}}) with go/no-go criteria from traces, metrics, and error rates of the critical flows (architecture.md section 8.4)
  - Tests:
    - [ ] MIG-7.4.T1 Each step compares error rate and latency of critical flows against legacy
    - [ ] MIG-7.4.T2 Rollback by routing rehearsed at least once before 100%
  - Comment:

- [ ] **MIG-7.5 — Observation window and legacy decommission**
  - Priority: P1 | Size: S | Risk: Med | Depends on: MIG-7.4
  - Target: after {{window}} without regressions, retire the legacy application and its unused resources; keep an archived artifact
  - Tests:
    - [ ] MIG-7.5.T1 No traffic reaches legacy during the window's last {{period}}
  - Comment:

## Traceability Matrix

| INV | Decision | Backlog item(s) | Test IDs |
|---|---|---|---|
| INV-01 | {{Replace}} | {{MIG-0.2, MIG-3.1}} | {{MIG-0.2.T1, MIG-3.1.T1…T4}} |

## Open Questions

- [ ] Q-01 {{question}} — blocks {{MIG-x.y}}
