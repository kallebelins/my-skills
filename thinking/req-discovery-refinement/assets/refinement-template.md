# [Topic name] - [ID]

> **Purpose:** starting point for discovery and requirements refinement. This document does not authorize implementation while blocking decisions remain open.
> **Status:** In discovery | **Business owner:** [Pending: who?] | **Date:** [YYYY-MM-DD]

## 1. Original Brainstorm

Preserve the ideas received from the client, without rewriting them as approved requirements.

- [Original idea]
- [Original idea]

## 2. Goal and Problem

- **Problem to solve:** [...]
- **Expected outcome for user/business:** [...]
- **Audiences and actors involved:** [...]
- **How success will be perceived or measured:** [...]

## 3. Discovery of the Existing Project

Investigate current behavior before proposing changes. Check relevant documentation and code, including tests, APIs, configuration, persistence and related flows, as applicable.

### 3.1 Current State

- **Flow/behavior found:** [Describe with evidence]
- **What already exists and can be reused:** [Components, services, screens, endpoints, data, configuration]
- **Confirmed gaps and limitations:** [Describe; do not infer absence from a single search]
- **Behaviors that must be preserved:** [...]

### 3.2 Evidence in the Project

| Finding | Verifiable evidence (file/symbol/test or URL) | Consequence for the requirement |
|---|---|---|
| [Finding] | [Path and symbol, test or reference] | [Consequence] |

Record confirmed facts, hypotheses and investigation gaps separately. Do not state that something does not exist without checking the relevant entry points and implementations.

## 4. Technical References and Market Practices

Research references relevant to the problem, prioritizing official documentation, recognized standards and primary sources. Record the consultation date and relate each recommendation to the project's context.

| Reference and URL | Type/authority | Relevant guidance | Applicability and adaptation to the project |
|---|---|---|---|
| [Title and URL] | [Official documentation, standard, study, etc.] | [Faithful summary] | [Applicable, partial or not applicable; justify] |

- **Practices adopted and why:** [...]
- **Practices discarded and why:** [...]
- **Research limitations:** [...]

Do not invent sources, statistics or market consensus. Distinguish external recommendations from business-approved decisions.

## 5. Actors, Scenarios and Desired Flow

### 5.1 Actors

| Actor | Goal | Relevant permissions/responsibilities |
|---|---|---|
| [Actor] | [Goal] | [...] |

### 5.2 Scenarios

- **Main scenario:** [Given the context, what does the actor do and what result do they get?]
- **Variations and exceptions:** [...]
- **Current flow and proposed change:** [Describe or reference a diagram]

## 6. Refined Requirements

Each requirement must be atomic, verifiable and traceable to the idea, evidence, decision or reference that motivated it. Mark its state as **Proposed**, **Validated** or **Blocked**.

| ID | Requirement | Origin/evidence | Priority | State |
|---|---|---|---|---|
| FR-01 | [The system must...] | [Brainstorm, evidence or decision] | [High/Medium/Low] | [Proposed/Validated/Blocked] |

### 6.1 Business Rules

- **BR-01:** [Rule, conditions and expected result. Origin/state: ...]

### 6.2 Non-Functional Requirements

Record only applicable ones, with measurable limits when possible: security and authorization, privacy, auditing, accessibility, performance, availability, resilience, observability, compatibility and cost.

- **NFR-01:** [Measurable requirement, context and origin/state]
- **Justification for non-applicable or undefined requirements:** [...]

### 6.3 Data, Integrations and Contracts (when applicable)

- **Input data and source:** [...]
- **Data persisted, changed or removed:** [...]
- **Affected integrations and contracts:** [...]
- **Validation, authorization and sensitive data handling:** [...]
- **Compatibility, migration and rollback:** [...]

## 7. Acceptance Criteria

Use observable results covering the main scenario, permissions, limits and relevant failures. Link each criterion to its requirements.

- [ ] **AC-01 (FR-01):** Given [context], when [action], then [verifiable result].
- [ ] **AC-02 (FR-01):** Given [limit, exception or failure], when [action], then [verifiable result].

## 8. Scope and Impacts

- **Included in this delivery:** [...]
- **Out of scope:** [...]
- **Potentially affected areas/components:** [..., with evidence]
- **Dependencies and prerequisites:** [...]
- **Compatibility or behavior that must not regress:** [...]
- **Test/validation strategy:** [...]
- **Deployment, activation, monitoring and rollback:** [..., when applicable]

## 9. Decisions and Open Questions

| ID | Question/decision | Impact if unresolved | Owner | State/deadline |
|---|---|---|---|---|
| D-01 | [Objective question] | [Blocked requirement or implementation] | [Client/team] | [Open/date] |

### Suggested Options for Open Decisions

For each open decision, record 3 options grounded in the discovery (section 3) and the references (section 4), with exactly one recommended. The user may choose one or provide another answer.

#### D-01 — [Short question]

| Option | Description | Grounding (evidence/reference) | Trade-offs |
|---|---|---|---|
| A (Recommended) | [Option] | [Path/symbol, test or reference] | [Pros and cons] |
| B | [Option] | [Path/symbol, test or reference] | [Pros and cons] |
| C | [Option] | [Path/symbol, test or reference] | [Pros and cons] |

- **Rationale for the recommendation:** [Why the recommended option best fits the project]
- **Other answer:** the user may describe an alternative different from the options above.

### Approved Decisions

- **D-XX:** [Decision] — approved by [owner] on [date]. **Alternatives considered:** [options and reason for the choice].

## 10. Risks, Assumptions and Recommendations

- **Risks:** [Cause, impact and possible mitigation]
- **Assumptions to validate:** [Do not treat as fact or approved requirement]
- **Discovery recommendations:** [Proposal, evidence and trade-offs]

## 11. Readiness for Specification/Implementation

- **Readiness:** [Ready for specification / Blocked by discovery]
- **Blockers:** [Decisions, evidence or criteria still needed]
- **Recommended next step:** [Ask the client, investigate the project, validate a reference or write the specification]
