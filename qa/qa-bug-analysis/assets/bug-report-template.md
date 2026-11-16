# BUG-NNN — [Short failure title]

> **Purpose:** failure analysis and fix plan (section 11), later executed by `spec-kit-executor` without creating a feature. Also serves as input for a task in the project's task tracker (optional).
> **Status:** [Under analysis | Awaiting information | Ready for fix | Requires specification | Fix in progress | Fixed] | **Diagnosis:** [Confirmed | Probable | Inconclusive] | **Date:** [YYYY-MM-DD] | **Reported by:** [Pending: who?]
> **Tracker:** [Not linked]

## 1. Original Report

Faithful transcription of what the user reported (do not rewrite it as a confirmed fact).

> [Report]

## 2. Identification

| Field | Value |
|---|---|
| Feature / screen / endpoint | [...] |
| Related feature | [feature-NNN or Not identified] |
| Environment | [Local / Development / Test / Staging / Production / Pending] |
| Date/time of occurrence | [... or Pending] |
| User profile/role | [... or Pending] |
| Browser / client | [... or Not applicable] |
| Frequency | [Always / Intermittent / Once / Pending] |
| Since when | [... or Pending] |
| Correlation ID / protocol | [... or Pending] |
| Probable layer | [Frontend / Backend / Database / Integration / Configuration / Infrastructure / Data] |
| Type | [Functional / Validation / Security-authorization / Performance / Integration / Data / Usability-accessibility / Regression] |
| Related/duplicate bugs | [docs/bugs/... or None found] |

## 3. Behavior

- **Observed behavior:** [...]
- **Expected behavior:** [...] — **Source:** [spec/rule/document with path, or "reported by the user"]
- **Error message / HTTP status:** [... mask sensitive data]

## 4. Steps to Reproduce

**Preconditions:** [data, profile, configuration]

1. [...]
2. [...]

**Result of the agent's reproduction attempt:** [Reproduced / Not reproduced / Not executed — reason]

## 5. System Investigation

### 5.1 Analyzed Flow

[Route → component → service → interceptor/guard → controller → domain service → repository → table/migration → integrations]

### 5.2 Evidence

| # | Finding | Evidence (path + symbol/line, test, masked log, commit) | Classification |
|---|---|---|---|
| E-01 | [...] | [...] | [Confirmed fact / Indication / Gap] |

### 5.3 Existing Test Coverage

- [Tests covering the flow, whether the failing scenario is covered, and whether any test asserts the incorrect behavior]

### 5.4 Relevant Recent Changes

- [commit — summary — file] or "None relevant found"

### 5.5 Investigation Limits

- [What could not be verified: production data, environment configuration outside the repository, remote logs, etc.]

## 6. Cause Hypotheses

| ID | Hypothesis | Evidence for | Evidence against | Likelihood | How to confirm |
|---|---|---|---|---|---|
| H-01 | [...] | [E-XX] | [...] | [High/Medium/Low] | [...] |

- **Most probable root cause:** [H-XX — objective explanation] or "Not identified"
- **Possibility of not being a defect:** [expected behavior, permission, data, environment — justify or "Ruled out"]

## 7. Impact and Severity

- **Users/processes affected:** [... or Pending]
- **Business impact:** [...]
- **Workaround:** [... or None known]
- **Security / sensitive data involved:** [Yes/No — detail]
- **Severity:** [Critical (system/process down, no workaround) | High (important function impaired) | Medium (failure with workaround) | Low (cosmetic/isolated)]
- **Suggested priority:** [High/Medium/Low — justify]

## 8. Fix Options (no implementation)

| Option | Approach | Affected components/files | Effort | Risks/side effects |
|---|---|---|---|---|
| A (Recommended) | [...] | [...] | [S/M/L] | [...] |
| B | [...] | [...] | [...] | [...] |

- **Rationale for the recommendation:** [...]
- **Requires database change:** [Yes (follow the project's naming conventions) / No]

## 9. Fix Acceptance Criteria

- [ ] **AC-01:** Given [failure context], when [action], then [verifiable expected result].
- [ ] **AC-02 (regression):** Given [adjacent scenario], when [action], then [behavior preserved].
- [ ] **AC-03 (automated test):** a [unit/integration/component] test exists that fails before and passes after the fix.

## 10. Pending Information

| ID | Question / data to collect | Why it matters | How to obtain | Owner |
|---|---|---|---|---|
| P-01 | [...] | [...] | [...] | [User/team] |

### Suggestions to Detail the Failure

- [Plausible causes not yet ruled out and what to observe to confirm them]
- [Recommended evidence: HAR/Network without tokens, Console, log lines by correlation ID, screenshot, read-only query in a non-production environment]

## 11. Fix Plan (tasks)

- **Routing:** [Direct fix (tasks below) | Requires specification (`spec-kit`) — reason | Awaiting information — P-XX]
- **Option to implement:** [A — summary]
- **Architecture reference:** [docs/<module>-architecture.md of each affected layer]
- **Affected repositories:** [name of each affected repository, if there is more than one]
- **Technical skills for execution:** [environment skills applicable to the stack, database and tests, or "None"]

<!--
Mandatory task format (one action per task; same format as spec-kit-3-tasks):

- [ ] X.Y - Task name
Description: {{one action}}
Architecture/Implementation: {{layer/pattern/convention, grounded in the architecture reference}}
Input: {{sections of this report: 8 (option), E-XX, H-XX}}
Output: {{exact path of the file to create or change}}
Test scenarios: {{from the report, section 4 and adjacent scenarios}}
Acceptance criteria: {{measurable, traceable to the AC-XX of section 9}}

X = Phase number; Y = sequence within the phase. Execution: spec-kit-executor, one task at a time.
When finished: "- [x]", "Comment:" and pending items as sub-tasks "- [ ] X.Y.N - ...". Do not renumber.
-->

### Phase 1 — Test that reproduces the failure

- [ ] 1.1 - [task name]
Description: [...]
Architecture/Implementation: [...]
Input: [...]
Output: [...]
Test scenarios: [...]
Acceptance criteria: [...]

### Phase 2 — Fix in [layer]

- [ ] 2.1 - [task name]
Description: [...]
Architecture/Implementation: [...]
Input: [...]
Output: [...]
Test scenarios: [...]
Acceptance criteria: [...]

### Phase 3 — Regression validation

- [ ] 3.1 - [task name]
Description: [...]
Architecture/Implementation: [...]
Input: [...]
Output: [...]
Test scenarios: [...]
Acceptance criteria: [...]

### 11.1 Inputs for Specification (only if "Requires specification")

- **Problem:** [...]
- **Expected behavior after the fix:** [...]
- **Fix requirements:** [FR-01 The system must ...]
- **Affected components:** [backend / frontend / database — paths]
- **Out of scope:** [...]
- **Acceptance criteria:** see section 9.

## 12. Task Tracker Summary (optional)

- **short_description (≤ 160):** `[<PROJECT>] Bug NNN - [title]`
- **Suggested type:** [Analysis / Coding / Testing]
- **Suggested environment:** [Development / Test / Staging / Production]
- **Planned hours (estimate):** [N h — basis: number of tasks in section 11 × hours per task]

Text in accessible language, without paths, repositories, classes, endpoints or task numbers.

```text
[<PROJECT>] Bug NNN - [title]

Context
[Symptom, where it occurs, environment and impact in 2–4 lines.]

Probable cause
[Cause summarized in plain language, with the diagnosis status.]

What will be fixed
- [expected result for the user/system]

How we will know it is done
- [verifiable criterion in plain language]

Pending items
- [pending item or "None"]

Estimate
- Planned hours: [N] h
```

## 13. Readiness

- **Readiness:** [Ready for fix | Requires specification | Awaiting information]
- **Blockers:** [... or None]
- **Recommended next step:** [collect P-XX / execute task 1.1 with `spec-kit-executor` / specify with `spec-kit` / register in the project's task tracker]
