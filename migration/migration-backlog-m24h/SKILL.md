---
name: migration-backlog-m24h
created by: Kallebe Lins | gh:kallebelins/my-skills
description: >-
  Plans the migration of an existing .NET project (any current version, including
  .NET Framework) to .NET 10 while replacing local implementations with the
  Mvp24Hours library. Produces two documents only: a migration architecture
  document and an executable migration backlog with a mandatory test for every
  migrated item, configuration preservation, and end-to-end observability and
  tracing. Grounds every decision in the mvp24hours MCP server. Use when the user
  wants to plan, scope, or backlog a migration to .NET 10 with Mvp24Hours; when
  local code (cache, resilience, mediator, logging, OpenAPI, time, options) should
  be replaced by Mvp24Hours equivalents; or before executing migration tasks.
argument-hint: "Plan the migration of this repo to .NET 10 with Mvp24Hours (keep current configs, expand tracing, test every moved item)"
---

# .NET 10 Migration Planner (Mvp24Hours)

## Purpose

Turn a request like "migrate this project to .NET 10 and use Mvp24Hours" into two reviewable, durable artifacts a human can execute with quality:

1. `docs/migration/architecture.md` — current-state inventory, target architecture, replacement map, configuration policy, observability design, testing strategy, risks.
2. `docs/migration/backlog.md` — ordered, traceable, checkbox-based actions. Every migrated item carries its own tests.

This skill is **planning only**. It never changes application source, project files, packages, or configuration.

## When to Use

- The user wants a plan/backlog to move a project from its current .NET version (Framework, Core 3.1, 5–9) to .NET 10.
- Local implementations should be replaced by Mvp24Hours ones (Mediator/CQRS, repositories and Unit of Work, cache, resilience, logging/telemetry, OpenAPI, time, options validation, messaging, health checks, etc.).
- The user needs observability and tracing expanded across all layers.
- The user wants a test-backed migration where each moved item is proven working.

**Not for:**

- Executing the migration tasks (use `task-executor-m24h` on the generated backlog).
- Planning new product features (use `spec-kit`).
- Creating the general project `docs/architecture.md` (use `spec-kit-architecture`).

## Non-Negotiable Rules

1. **MCP first.** The `mvp24hours` MCP server is the source of truth about the library. Never cite a package, type, extension method, or doc path from memory. Verify it with the MCP (see *MCP Tool Map*). Library `src/` and `src/Tests/` override docs when they conflict.
2. **If the MCP is unavailable, stop.** Tell the user which server is missing and ask them to enable it. Do not continue from memory. Partial work may continue only for repository discovery (Step 2), and every library claim stays marked `unverified`.
3. **Planning only.** Write only `docs/migration/architecture.md` and `docs/migration/backlog.md` (and create `docs/migration/`). No edits to `*.cs`, `*.csproj`, `Directory.*.props`, `global.json`, `appsettings*`, CI, or NuGet packages.
4. **Keep current configuration.** Preserve existing keys, sections, environment-variable names, and values. Configuration may only be *bound* differently (Options pattern), never renamed or moved, unless the user approves it in writing. New keys are additive only.
5. **No secrets work.** Do not introduce secret stores, user secrets, vault providers, or secret rotation. Do not open `.env` or key/credential files beyond what discovery needs, never copy secret values into any document, and refer to them by key name only. Record this as an explicit deviation (see *Secrets Policy*).
6. **Every migrated item has tests.** No backlog item that moves, replaces, or removes code may exist without concrete test tasks. A migration item is not "done" until its tests pass.
7. **No dual implementations.** The backlog must never register the legacy and the Mvp24Hours implementation for the same service in one host. With `in-place`, each item ends with the legacy code removed. With `parallel`, the new application never contains the legacy implementation, and the legacy application stays untouched until the final decommission item.
8. **No invention.** Inventory facts come from files you read. Unknowns are written as `unknown`, not guessed.
9. **Parallel migration with contract parity is the default.** Unless the user chooses otherwise, the .NET 10 application is built side by side with the running legacy application (two deployables, never two implementations in one container) and MUST keep the public contract identical: routes, verbs, status codes, request/response schemas, headers, error shape, authentication behavior, and serialization. A contract change is allowed only as a separate, user-approved backlog item with versioning (see *Strategy and Contract Policy*).

## Inputs

| Input | Required | Notes |
|---|---|---|
| Repository root | **Yes** | Default: workspace root |
| Source paths / scope | No | Subfolders or solutions in scope; default: whole repo |
| Target framework | No | Default `net10.0` |
| Migration strategy | No | `parallel` (default, recommended) \| `in-place` \| `strangler-by-module`. See *Strategy and Contract Policy* |
| API contract policy | No | `parity` (default, recommended) \| `controlled-changes` (each change approved individually and versioned) |
| Critical flows for production tracing | No | If missing, propose 3–7 from discovery and mark `proposed` |
| Deployment context | No | Hosting, environments, CI; `unknown` if not given |
| Language of the documents | No | Default: the language the user wrote in; keep IDs, tool names, and code identifiers in English |

Ask only for what cannot be discovered. Batch all questions in a single message.

## MCP Tool Map

Use these `mvp24hours` MCP tools. Load their schemas first if your client defers tool loading.

| Need | Tool |
|---|---|
| Port/discovery workflow | `get_discovery_playbook`, `list_scenarios`, `get_scenario_playbook` (`port-to-mvp24hours`, `upgrade-net10`, `legacy-migration`) |
| Pick target architecture | `resolve_architecture`, `get_architecture_template`, `list_layers`, `suggest_project_structure` |
| Compare with current layout | `plan_architecture_migration` (template → template) |
| Map a capability to the library | `resolve_feature` (e.g. `cqrs`, `opentelemetry`, `rabbitmq`, `cronjob`, `health-checks`, `keycloak`), `search_docs`, `get_doc` |
| Version/package upgrade | `get_migration_playbook` (`package-9-to-10`, `legacy-to-native-apis`, `simple-to-complex-nlayers`), `get_doc` → `migration.md`, `modernization/migration-guide.md` |
| Reference implementations | `list_samples`, `get_sample_tree`, `search_sample_patterns`, `get_sample_file` |
| Composition root | `get_di_registration_hints` |
| Prove an API exists | `find_source_symbol`, `verify_doc_claim` |
| Tests | `find_tests_for_module`, `get_test_scaffold` |
| Compliance | `run_compliance_check` |

## Procedure

### Step 1 — Preflight

1. Confirm the `mvp24hours` MCP server responds (call `list_scenarios`). If it fails, apply Rule 2.
2. Confirm the repository root and scope. Check whether `docs/migration/architecture.md` or `docs/migration/backlog.md` already exist. If they do, switch to **amend mode**: read them, preserve completed `[x]` items and their Comment/Status blocks, add new items with new IDs, never renumber.
3. Record header facts: project name, today's date, git branch/commit when available, and the Mvp24Hours version reported by the MCP (`get_doc` → `home.md` or `release.md`).

### Step 2 — Discovery (read-only)

Follow `get_discovery_playbook` Phase A. Collect verified evidence for:

| Area | What to capture |
|---|---|
| Solution | Every `*.sln`/`*.slnx`/`*.csproj`: `TargetFramework(s)`, SDK style vs legacy csproj, `LangVersion`, Nullable, Central Package Management, `global.json` |
| Packages | Every `PackageReference` and version, including any existing `Mvp24Hours.*`, MediatR, AutoMapper, FluentValidation, Polly, Swashbuckle, Serilog, Dapper, EF Core provider, broker/cache clients |
| Startup | `Startup.cs` vs `Program.cs`, `web.config`, OWIN/`System.Web` usage (Framework only), hosting model |
| Configuration | `appsettings*.json`, `web.config`/`app.config`, env-var usage, `IConfiguration`/`ConfigurationManager` call sites. **Keys and sections only, never values of credentials.** |
| Local implementations | Custom mediator/dispatcher, repository/UoW, cache wrappers, retry/circuit-breaker helpers, logging/telemetry helpers, Swagger setup, mapping, validation, time helpers (`DateTime.Now`, static clocks), timers, rate limiting, HTTP client factories (`new HttpClient()`), message publishers/consumers, auth, health endpoints, background jobs |
| Observability today | Logging framework, sinks, correlation IDs, any tracing/metrics, health endpoints |
| Tests | Test projects, frameworks, coverage of each local implementation, how tests run |
| Build/CI | Build, test, lint commands; pipeline files |

Baseline: when the toolchain is available, run `dotnet --info`, `dotnet restore`, `dotnet build`, and `dotnet test` once and record build warnings and test results. If something cannot run, record `unknown` with the reason. Do not fix anything.

For each local implementation, create a numbered inventory entry `INV-NN` with its verified path(s). Code wins over existing docs on any divergence.

### Step 3 — Map to Mvp24Hours (MCP)

1. `resolve_architecture` with the discovery summary; then `get_architecture_template`, `list_layers`, `suggest_project_structure`.
2. Compare the recommended template with the current structure. If they differ materially (`plan_architecture_migration` or layer diff), **do not assume a restructure**: default to preserving the current layout and ask the user to confirm before planning a restructure. Record the answer as a decision.
3. For each `INV-NN`, call `resolve_feature` and, when needed, `search_docs`, `search_sample_patterns`, and `get_sample_file`. Classify:

| Decision | Meaning |
|---|---|
| `Replace` | Mvp24Hours (or a native .NET 10 API it wraps) covers it; local code is removed |
| `Adopt` | New capability to add (for example end-to-end observability) |
| `Keep` | No equivalent, or replacing adds risk without value; justify in one line |
| `Remove` | Dead or redundant code |
| `Decide` | Needs a human decision; becomes an open question |

4. Prove each target API exists: `find_source_symbol` or `verify_doc_claim`. Store the symbol, package, and doc path in the replacement map. Unverified targets are marked `unverified` and cannot be used by a backlog item until resolved.
5. Load the relevant playbooks: `get_migration_playbook` for `package-9-to-10` (when Mvp24Hours is already in use) and `legacy-to-native-apis`; read `migration.md` and `modernization/migration-guide.md`. Carry over every breaking change and behavior change that applies (nullable diagnostics, removed APIs, time-zone behavior, SQL client, encryption compatibility, OpenAPI, telemetry removal, and so on) as backlog items or risks.
6. `get_di_registration_hints` for the target template to describe the `Program.cs` composition root.
7. For test tooling: `find_tests_for_module` and `get_test_scaffold`.

### Step 4 — Design the Cross-Cutting Decisions

**Strategy and Contract Policy.** Record both choices in the architecture document. Defaults: `parallel` + `parity`.

| Strategy | Meaning | Planning consequences |
|---|---|---|
| `parallel` (default) | New .NET 10 solution runs side by side with the legacy application; traffic moves only after parity is proven | Legacy stays untouched and deployable; new projects live in a separate solution/folder/branch; cutover and rollback are routing decisions outside the code (gateway, load balancer, DNS, or the host's existing mechanism) |
| `in-place` | The existing projects are retargeted and changed directly | Higher risk; each item needs its own rollback; only when the user asks for it |
| `strangler-by-module` | Modules or routes move one by one behind a facade/router | Needs a routing layer and a per-route parity gate |

With `parity`, the contract is a frozen artifact:

- Capture the legacy contract **before** building: OpenAPI/Swagger document if present, otherwise an inventory of routes, verbs, status codes, DTO shapes, headers, error payloads, auth requirements, pagination, and serialization settings (property casing, enum format, date/time format, null handling).
- Name every place where the migration can silently alter the contract: Swashbuckle → native OpenAPI output, `System.Text.Json` vs Newtonsoft defaults, ProblemDetails vs legacy error shape, model binding and validation messages, status codes for validation failures, routing conventions, CORS, and middleware ordering. Each becomes a parity test or a documented, approved exception.
- Add a **contract parity harness** item: the same request suite runs against legacy and new instances (base URL parameterized) and compares status, headers that matter, and body shape (semantic JSON diff, ignoring agreed volatile fields such as timestamps and generated ids). Optionally add shadow/replay comparison of real traffic when the environment allows it.
- Shared resources: when both applications use the same database, cache, or broker, the plan MUST state how they coexist. Default: schema changes are backward compatible (expand, then contract later), the new application does not apply migrations against the shared database until cutover is approved, and consumers/jobs are enabled on only one side at a time to avoid double processing.
- Cutover is gradual when possible (small percentage or internal users first), with a rollback that is only a routing change. Decommissioning the legacy application is a separate final item after a stable observation window.
- The MCP warning against registering legacy and native implementations in the same container still applies: `parallel` means two deployables, not two implementations inside one host.

**Configuration preservation.** Build a table of every configuration section/key in use → the options class that will bind it → status `preserved`. Bind through `IOptions<T>` with `ValidateOnStart`, keeping the same keys. Add a parity test task per section (see *Testing Rules*). New observability settings use a new section or standard `OTEL_*` variables and are additive.

**Observability and tracing.** Design per layer, end to end, using `resolve_feature` → `opentelemetry`/observability docs and the library's own symbols (verify them):

| Layer | Must cover |
|---|---|
| Host / API | Inbound HTTP spans, ProblemDetails correlation with trace id, health/readiness, metrics (request rate, errors, duration) |
| Application | A span per use case (handler/service), Mediator observability behaviors when CQRS is adopted, business-level counters |
| Domain / Core | No infrastructure dependencies; domain/integration events carry correlation context |
| Infrastructure | Database, cache, HTTP clients, broker publish/consume, external calls; context propagation across process boundaries |
| Workers / jobs | A root span per execution, propagation from messages, failure and duration metrics |
| Logging | `ILogger<T>` everywhere, structured, enriched with trace/span ids |

Define two profiles:

| Profile | Sampling | Detail | Export |
|---|---|---|---|
| Development | 100% | All layers, verbose, SQL/HTTP detail allowed | Console and/or local OTLP collector/dashboard |
| Production (principal flows only) | Parent-based ratio; always sample listed critical flows and errors | Entry points, critical use cases, external dependencies, errors | OTLP exporter |

Rules: no PII/secret/payload in span attributes, low-cardinality names, consistent naming per layer, and a documented list of **critical flows**. Observability is implemented as backlog items, each with tests that assert spans/metrics/log correlation (for example with in-memory exporters).

**Secrets Policy.** The MCP compliance checklist asks for secrets from environment variables, user secrets, or a secret store. This project explicitly does not apply secrets handling in this migration. Record it as deviation `D-001` in the architecture document (what, why, accepted by the user, risk) and never raise it as a backlog item. Only note in the risks section that credentials already present in configuration are out of scope and must not be copied into docs or test fixtures.

**Testing rules.** See the dedicated section below. Decide tools from the existing test stack first; fall back to the stack recommended by `get_test_scaffold`.

### Step 5 — Write `docs/migration/architecture.md`

Use `migration/migration-backlog-m24h/templates/migration-architecture.template.md` as the exact structure. Fill every section. Set `status: draft` while open questions or `unverified` items remain, otherwise `status: active`. Keep only verified facts; cite file paths and MCP sources (tool + argument or doc path).

### Step 6 — Write `docs/migration/backlog.md`

Use `migration/migration-backlog-m24h/templates/migration-backlog.template.md`. Build phases in this order and add items only where the inventory justifies them:

| Phase | Goal |
|---|---|
| 0 — Baseline & safety net | Freeze build/test baseline; capture the **API contract** (OpenAPI or inventory) and add **characterization tests** on the legacy behavior of each item that will move, *before* it moves |
| 1 — Toolchain & target framework | .NET 10 SDK, `global.json`. With `parallel`: create the new .NET 10 solution beside the legacy one. With `in-place`: retarget to `net10.0`. Nullable/ImplicitUsings, Central Package Management, `Startup` → `Program.cs`, Framework-only porting items |
| 2 — Mvp24Hours adoption | Add packages at one aligned version, composition root per `get_di_registration_hints`, apply breaking-change items from the playbooks |
| 3 — Replace local implementations | One item per `INV-NN` with decision `Replace`/`Remove`, ordered by dependency and risk (low risk and leaf dependencies first) |
| 4 — Observability & tracing | Items per layer and per critical flow, dev and prod profiles |
| 5 — Configuration parity | Options classes, validation, parity tests for every preserved section |
| 6 — Hardening & compliance | `run_compliance_check`, `dotnet list package --vulnerable --include-transitive`, release build with warnings as errors, remove leftovers |
| 7 — Rollout | With `parallel`: contract parity run against legacy, shadow/gradual cutover, observation window, rollback by routing, legacy decommission as the last item. Always: environment validation, smoke tests, health endpoints, rollback checklist |

With `parallel` + `parity`, also add, in Phase 0 or 1, a **contract parity harness** item, and in Phase 3 a **per-endpoint (or per-module) parity test** sub-task for every migrated endpoint.

Every item follows the template fields (priority, size, risk, dependencies, source, target with verification, configuration impact, observability, **required tests**, acceptance criteria, Comment). Items are independently mergeable, numbered `MIG-<phase>.<n>`, with sub-tasks `MIG-<phase>.<n>.<k>`. The checkbox format is compatible with `task-executor-m24h`, which updates the item in place.

End the backlog with the **Traceability Matrix** (`INV-NN` → `MIG-x.y` → test IDs).

### Step 7 — Validate

1. Run `run_compliance_check` over the current source paths to capture baseline findings. Convert findings that apply into backlog items or risks; list the ones intentionally skipped (for example secrets, `D-001`).
2. Walk the *Verification* checklist below.
3. Fix gaps before handing off.

### Step 8 — Handoff

Report to the user:

- Paths of the two documents and their `status`.
- Counts: inventory items, backlog items per phase, test tasks.
- Open questions and `unverified`/`unknown` items that need an answer.
- Decisions that need confirmation (for example restructure vs preserve layout).
- Next step: execute items in order with `task-executor-m24h`, starting at Phase 0.

## Testing Rules

- **Pre-migration safety net.** For each item with decision `Replace`, add a characterization test on the legacy implementation first (Phase 0). The same test must pass after the swap, proving parity.
- **One test set per moved item**, as sub-tasks `MIG-x.y.T1…`. Pick the applicable types:

| Item type | Required tests |
|---|---|
| Pure logic / helpers | Unit tests, including edge cases and cancellation |
| Repository / UoW / EF | Integration tests against the real provider (Testcontainers, skipped when Docker is unavailable) or EF InMemory in the `Testing` environment, plus transaction behavior |
| Cache | Hit/miss, expiration, invalidation, concurrency |
| Resilience | Retry count, timeout, circuit-breaker state with a fake handler and `FakeTimeProvider` |
| Mediator / CQRS | Handler tests, pipeline behavior order, validation failures |
| HTTP API | `WebApplicationFactory<Program>` smoke and contract tests, OpenAPI document (`/openapi/v1.json`) non-5xx, ProblemDetails shape |
| API contract parity | The same request suite against legacy and new instances; compare status, relevant headers, and JSON shape; OpenAPI document diff; serialization (casing, enums, dates, nulls); error payloads and validation status codes; auth behavior |
| Messaging / workers | Publish/consume round-trip, idempotency, failure path |
| Time | `FakeTimeProvider`, including time-zone parity when replacing a time-zone helper |
| Configuration | Binding parity: same keys produce the same values; invalid values fail at startup |
| Observability | Spans, metrics, and log correlation asserted through in-memory exporters |

- Naming `Method_Scenario_Expected`; traits `[Trait("Category","Unit")]` or `Integration`. Follow the project's existing framework and conventions over the defaults.
- A legacy-to-native change with known behavior differences (for example time zone, encryption, SMTP TLS, SQL client) needs an explicit behavior test, not only a smoke test.

## Output

- `docs/migration/architecture.md` (template: `templates/migration-architecture.template.md`)
- `docs/migration/backlog.md` (template: `templates/migration-backlog.template.md`)

## Verification

Before finishing:

- [ ] MCP server was reachable and used; every library claim is backed by an MCP result or marked `unverified`.
- [ ] Only the two documents were created or modified; no source, csproj, package, or config file changed.
- [ ] Inventory items (`INV-NN`) cite verified file paths; gaps are `unknown`, not guessed.
- [ ] Every `Replace`/`Remove`/`Adopt` inventory item maps to at least one backlog item, and each backlog item maps back (Traceability Matrix is complete).
- [ ] Every backlog item that moves code has test sub-tasks, including a pre-migration characterization test when replacing.
- [ ] Every current configuration section is listed as `preserved`; no key is renamed without recorded user approval.
- [ ] No secret values appear in any document; `D-001` documents the secrets deviation.
- [ ] Observability covers every layer, defines dev and production profiles, lists critical flows, and has test items.
- [ ] No item registers legacy and Mvp24Hours implementations together.
- [ ] Strategy and contract policy are recorded (default `parallel` + `parity` unless the user chose otherwise).
- [ ] With `parity`: the legacy contract capture, the parity harness, a parity test per migrated endpoint, the shared-resource coexistence plan, and the cutover/rollback/decommission items exist.
- [ ] Any contract change is a separate, user-approved, versioned backlog item.
- [ ] Phases 0–7 are present (or an omission is justified), ordered by dependency.
- [ ] Open questions are listed; `status` matches reality (`draft` vs `active`).
- [ ] No unexplained `{{placeholder}}` tokens remain.

## Example Prompt (recommended)

```text
Planeje a migração deste projeto da versão atual do .NET para o .NET 10, substituindo
as implementações locais pelas equivalentes do Mvp24Hours.

Use o MCP mvp24hours como fonte de verdade sobre a biblioteca.

Restrições:
- Mantenha as configurações atuais (chaves, seções, variáveis de ambiente e valores). Não aplicaremos secrets.
- Expanda observabilidade e tracing para todas as camadas, com acompanhamento ponta a ponta
  em desenvolvimento e parcial em produção (apenas os fluxos principais).
- Cada item migrado deve ter testes (incluindo teste de caracterização antes da troca).
- Ao final, tudo deve estar funcionando: build sem warnings como erro, testes verdes, compliance check limpo.

Nesta fase, gere apenas:
1. docs/migration/architecture.md (documento de arquitetura da migração)
2. docs/migration/backlog.md (backlog executável com as ações para eu migrar o projeto com qualidade)

Não altere código-fonte, projetos ou pacotes.
```

Estratégia e contrato (acrescente ao prompt quando quiser algo diferente do padrão `parallel` + `parity`):

```text
Estratégia: em paralelo (nova solução .NET 10 ao lado da atual), com paridade de contrato da API.
Mudanças de contrato só como itens separados, versionados e aprovados por mim.
```
