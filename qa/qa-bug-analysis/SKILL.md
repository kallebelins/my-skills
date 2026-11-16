---
name: qa-bug-analysis
description: "Investigates a reported bug (symptom, screen, endpoint, error, environment) against the real code, docs, tests, config and local logs, WITHOUT fixing anything, and writes docs/bugs/bug-NNN-<short-name>.md: root cause with evidence, ranked hypotheses, impact, reproduction, fix options, acceptance criteria, task-tracker summary and, at the end, a detailed fix plan (one-action tasks X.Y by phase, spec-kit-3-tasks format) executed later by spec-kit-executor without creating a feature. When the cause is not found, guides the user to detail the failure. WHEN: analyze bug, investigate bug, bug triage, plan bug fix, fix plan tasks, production error, unexpected behavior, register bug, bug report. DO NOT USE FOR: fixing code (use spec-kit-executor), writing feature spec.md/plan.md/tasks.md, creating the tracker task, SonarQube issues."
argument-hint: "Describe the failure: what happens, where (screen/endpoint), expected behavior, environment, error message/log, steps"
---

# Bug Analysis and Fix Plan (no code changes)

## Purpose

Turn a user's bug description into one detailed, evidence-based analysis report in `docs/bugs/`, ending with a **fix plan** (section 11): one-action tasks in the same format as `spec-kit-3-tasks`, so that (a) `spec-kit-executor` can execute the fix directly from the report — **no feature, `spec.md`, `plan.md`, `tasks.md` or backlog entry is created** — and (b) the summary in section 12 can be pasted into the project's task tracker (optional). The skill **diagnoses and plans only**; it never changes application code, configuration or data.

Only fixes that restore behavior already defined (spec, documented rule or user-confirmed expectation) are planned here. If the fix needs new scope (new/changed business rule, new endpoint/screen/table, contract change, or the expected behavior is undefined/disputed), set **Requires specification**, fill section 11.1 and do not generate tasks; the fix then goes through `spec-kit`.

## When to Use

- **Mode A — Investigate:** the user describes a failure; locate it in the system and diagnose it.
- **Mode B — Detail the failure:** the failure cannot be located or confirmed in the system (or the description is too vague); help the user detail it with suggested causes, targeted questions and what evidence to collect. Mode A falls back to Mode B automatically.
- **Mode C — Update:** the user provides an existing `docs/bugs/bug-NNN-*.md` with new information; update it in place (with agreement) and re-evaluate. If the fix plan already has tasks `[x]` or with `Comment:`, never renumber, reorder or delete them; only append new tasks or `X.Y.N` sub-tasks.

## When Not to Use

- Applying the fix (execute the tasks of section 11 with `spec-kit-executor`).
- Writing feature `spec.md`/`plan.md`/`tasks.md` or creating/updating a task in an external tracker.

## Inputs

| Input | Required | If missing |
|---|---|---|
| Symptom (what happens) | Yes | Ask before starting. |
| Location (screen, route, endpoint, job, feature) | No | Infer from the symptom via search; otherwise ask (Mode B). |
| Expected behavior | No | Infer from specs/docs when evidenced; otherwise ask. |
| Environment (local, development, test, staging, production), date/time, user profile | No | Ask; record as pending if unknown. |
| Error message, HTTP status, correlation ID, logs, screenshots | No | Ask in Mode B; never require secrets. |
| Steps to reproduce, frequency, since when | No | Ask in Mode B. |
| Short name | No | Derive from the symptom (kebab-case, English, ≤ 5 words, no accents). |
| Tracker import (ticket/story text, comments, images) | No | Text provided by the user or by an integration available in the environment; never fetch the tracker from this skill. |

## Preconditions

- [ ] [assets/bug-report-template.md](assets/bug-report-template.md) read in full in this session.
- [ ] Output path resolved: `docs/bugs/bug-NNN-<nome-curto>.md`, `NNN` = next free 3-digit number in `docs/bugs/` (create the folder if missing). If a report for the same failure already exists → ask whether to update it (Mode C) or create a new one.
- [ ] [../spec-kit-3-tasks/SKILL.md](../spec-kit-3-tasks/SKILL.md) read in this session (task format and field rules reused in section 11).

## Procedure

### 1. Capture the report

1. Record the user's description verbatim (template section 1). Never rewrite it as a confirmed fact.
   - **From a tracker import:** section 1 holds the imported title, description and comments verbatim, preceded by the origin (ticket identifier, author, date). List each image with a relative link (`assets/bug-NNN/img-NN.<ext>`) or `not available`, and describe what it shows; cite images used as evidence as `E-XX`.
2. Extract searchable terms: screen/route names, labels, endpoint paths, HTTP codes, exception names, error messages, table/column names, feature numbers.
3. If the symptom is missing → ask. If other inputs are missing → continue and ask later (Step 5) only what is needed.

### 2. Map the context

1. Read the architecture documents under `docs/` (`docs/*architecture*.md`) for the layer(s) involved (e.g. frontend, backend, database) to know where each concern lives.
2. Search `docs/backlog.md`, `docs/specs/feature-*/spec.md` and `docs/bugs/` for the feature/flow and for related or duplicate bugs; read the relevant ones. The spec defines the **expected behavior**.
3. Check recent changes in the involved files: `git --no-pager log --oneline -n 20 -- <path>` in the repository that owns each file (when the workspace has several repositories, identify them with `git rev-parse --show-toplevel`).

### 3. Trace the flow in code

1. Follow the flow end to end as applicable, using the layers described in the architecture documents: UI route/component → client service → HTTP interceptor/guard → API entry point (controller/handler) → domain/application service → repository/persistence → database migration → external integrations; plus configuration files, security (authentication/authorization, roles) and error handling (exception handlers, response wrappers).
2. Read the files supporting each step; record evidence as relative path + symbol (and line when useful).
3. Inspect existing tests covering the flow: is the failing scenario tested? Does a test assert the wrong behavior?
4. Read-only diagnostics allowed: local log files (`*.log`, `logs/`), `git log/blame/diff`, and running **existing** tests or builds to reproduce (`mvn -q test -Dtest=<Class>`, `npm test -- <spec>`). Never edit files, create new tests in the repos, change data or call production systems.
5. Never print or copy secrets, tokens, passwords or personal data from logs/config into the report; mask them (`***`).

### 4. Diagnose

1. List hypotheses for the cause. For each: description, supporting evidence, contradicting evidence, likelihood (**High/Medium/Low**) and how to confirm.
2. Classify the diagnosis:
   - **Confirmed** — the defect is identified in code/config/data with evidence (or reproduced);
   - **Probable** — strong evidence but not reproduced/confirmed;
   - **Inconclusive** — no evidence found → go to Step 5 (Mode B).
3. Also classify: layer (Frontend/Backend/Database/Integration/Configuration/Infrastructure/Data), type (functional, validation, security/authorization, performance, integration, data, usability/accessibility, regression) and whether it may be **not a bug** (expected behavior per spec, permission, data, environment) — say so explicitly.
4. Assess impact and severity using the template scale; propose priority. Do not invent user counts or financial impact; ask instead.
5. Describe 1–3 fix options (approach, files/components to change, effort, risk, side effects) and mark one as recommended. **Describe; do not implement.**
6. Write regression acceptance criteria (Given/When/Then) for the fix, including the original scenario and at least one adjacent scenario that must not break.

### 5. Help detail the failure (Mode B or missing inputs)

1. Save the report first (Step 7) with what is known, so nothing is lost.
2. Present the most plausible causes for the symptom in this architecture (e.g. missing role/claim in the authentication token, CORS/proxy, expired session, data in unexpected state, migration not applied in the environment, divergent environment configuration, frontend validation vs backend validation mismatch, integration timeout), each with why it fits and how to confirm it.
3. Ask targeted questions with the interactive tool (`ask_user`), at most 4–5 per form, highest diagnostic value first. Offer suggested answers when possible. Typical questions: environment, exact message/HTTP status, correlation ID/time, profile/role, steps, frequency, since when, affects all users or one, data used (masked), browser.
4. Recommend what to collect and how (browser DevTools Network/Console with HAR without tokens, backend log lines filtered by correlation ID, screenshot, SQL query read-only on non-production) — never ask the user to share secrets.
5. With new answers → return to Step 3/4 and update the report. Stop when the user has no more information; keep remaining items as pending.

### 6. Build the fix plan (section 11)

1. Decide the **Routing**:
   - **Direct fix** — diagnosis Confirmed/Probable, expected behavior evidenced or confirmed by the user, acceptance criteria defined and the recommended option only restores that behavior → generate tasks.
   - **Requires specification** — the fix needs new scope (see Purpose) → do not generate tasks; fill 11.1 so `spec-kit` can start without re-investigation.
   - **Awaiting information** — diagnosis Inconclusive or blocking P-XX → do not generate tasks; list the blockers.
2. If the recommended option is not obvious, confirm it with the user (`ask_user`) before detailing tasks.
3. Read the architecture reference of each affected layer (the `docs/*architecture*.md` files found in Step 2) and record it in **Architecture reference**; list the technical skills available in the environment that the execution will need (for example the project's stack, database or testing skills, such as `qa-java-unit-tests`).
4. Organize phases (`### Phase X — <name>`) by dependency. Default order, removing phases that do not apply:
   1. **Test that reproduces the failure** — automated test that fails for the reason diagnosed (AC "automated test"); when the diagnosis is Probable, this phase also confirms the hypothesis.
   2. **Fix** — one phase per layer, in the order database → backend → frontend (e.g. `Phase 2 — Fix in the backend`).
   3. **Regression validation** — adjacent scenarios (regression AC), run of the affected test suites/build and, when applicable, manual verification steps from section 4.
5. Write each task in the exact `spec-kit-3-tasks` format and field rules, adapted to the report:
   - **Input** cites sections of this report (`section 8 — option A`, `E-XX`, `H-XX`, `section 4`) instead of `spec.md`.
   - **Architecture/Implementation** is grounded in the architecture reference and in the code read in Step 3; if they do not cover the case → ask; never invent.
   - **Output** is the exact path relative to the repository root (prefixed by the repository folder name when the workspace has several repositories); new test files follow the existing test layout.
   - **Acceptance criteria** cite the `AC-XX` of section 9; every AC of section 9 is covered by at least one task.
   - One action per task; number `X.Y`; all tasks `- [ ]`.
6. Any database object name in a task follows the project's database naming conventions (from the architecture reference or an available skill; read it when the fix touches the database).

### 7. Write and save the report

1. Fill **every** section of the template in order, in English. Replace each placeholder with content, `Not applicable` + justification, or a specific pending question.
2. Fill section "Task Tracker Summary" (optional, for the project's tracker): `short_description` ≤ 160 characters with prefix `[<PROJECT>] Bug NNN - ` (use the project's own prefix, or omit it), description ≤ 4000 characters in accessible language without local references (paths, repositories, classes, endpoints, task numbers), suggested type/environment and planned hours (estimate = number of tasks in section 11 × hours per task, using the team's own estimate per task; mark as estimate).
3. Keep the header line `Tracker:` as `Not linked`; it is updated only when the user links the report to a tracker item.
4. Set **Status** and **Readiness** consistently with the Routing: `Ready for fix` (tasks generated), `Requires specification` (11.1 filled) or `Awaiting information` (blockers listed). Statuses `Fix in progress` and `Fixed` belong to `spec-kit-executor`.
5. Save the file. Never overwrite an existing report without agreement.

## Rules

### MUST

- Ground every finding in a path + symbol, test, log excerpt (masked), commit or user statement.
- Separate user report, confirmed facts, hypotheses and recommendations.
- Mark explicitly what was not verified (e.g. production data, environment config not in the repo).
- Keep the fix plan inside the report (section 11), in English, with the `spec-kit-3-tasks` task format.

### MUST NOT

- Change application code, tests, configuration, migrations or data; open PRs; create or update tracker items.
- Create a feature folder, `spec.md`, `plan.md`, `tasks.md` or a `docs/backlog.md` entry for the bug.
- Generate tasks when the Routing is `Requires specification` or `Awaiting information`.
- Invent stack traces, log lines, metrics, users affected or root causes.
- Expose secrets or personal data.
- Mark a hypothesis as confirmed without evidence.

## Resources

| File | When to read |
|---|---|
| [assets/bug-report-template.md](assets/bug-report-template.md) | Always, in full, before writing (Preconditions). |
| [../spec-kit-3-tasks/SKILL.md](../spec-kit-3-tasks/SKILL.md) | Before Step 6 (task format and field rules). |

## Handoff

| Direction | Skill | Data |
|---|---|---|
| Fix plan executed by | [spec-kit-executor](../spec-kit-executor/SKILL.md) | One task `X.Y` of section 11 at a time |
| Requires specification → | [spec-kit](../spec-kit/SKILL.md) | Section 11.1 |

## Output

- One file `docs/bugs/bug-NNN-<nome-curto>.md` following the template, including the fix plan.
- Final message (English): path, diagnosis status and probable cause in 1–2 lines, main evidence, recommended fix option, Routing with the number of phases/tasks, pending information, and next steps (execute task `1.1` with `spec-kit-executor`, or `spec-kit` when it requires specification; optionally paste section 12 into the task tracker).

## Done Criteria

- [ ] All template sections present, in order, with no generic placeholders.
- [ ] Every hypothesis has evidence for/against and likelihood.
- [ ] Diagnosis status consistent with the evidence.
- [ ] Routing consistent with diagnosis, expected behavior and scope.
- [ ] When `Direct fix`: every task has Description, Architecture/Implementation, Input, Output, Acceptance criteria (Test scenarios omitted only when none apply); one action per task; `X.Y` numbering; every AC of section 9 covered; first phase reproduces the failure.
- [ ] Tracker summary within the character limits and without local references.
- [ ] No file changed outside `docs/bugs/` (images of an imported bug go to `docs/bugs/assets/bug-NNN/`).
