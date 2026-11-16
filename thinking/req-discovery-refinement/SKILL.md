---
name: req-discovery-refinement
description: "Turns a client brainstorm (pasted text or file) into a requirements refinement document grounded in the real state of the project (code/docs discovery with verifiable evidence) and in verified external references, filling every section of the bundled template; also helps answer the open decisions (D-XX) of an existing refinement with 3 grounded options each, one recommended. WHEN: refine brainstorm, requirements refinement, discovery before spec, research market practices for a feature, answer open decisions of a refinement. DO NOT USE FOR: writing spec.md/plan.md/tasks.md, changing application code, backlog maintenance."
argument-hint: "Brainstorm text or input file path and, optionally, output directory/file name; or the path of an existing refinement to answer its open decisions"
---

# Requirements Discovery and Refinement

## Purpose

Produce one refinement document that preserves the original brainstorm, separates confirmed facts from proposals, grounds every finding in project evidence or verified external sources, and makes explicit what still depends on the client.

## When to Use

- **Mode 1 — Refine:** the user provides a brainstorm (file or pasted text) and asks for refinement, discovery or market-practice research before specification.
- **Mode 2 — Answer decisions:** the user provides an existing refinement and asks for help answering its open decisions (`D-XX`). Go straight to Step 5; complement discovery/research only as needed to ground the options.

## When Not to Use

- Writing specifications, plans or tasks.
- Implementing code.

## Inputs

| Input | Required | Source | If missing |
|---|---|---|---|
| Brainstorm (Mode 1) | Yes | File path in the workspace or text pasted in the conversation | Ask for it before starting. |
| Existing refinement file (Mode 2) | Yes | User | Ask for the path. |
| Tracker import (ticket/story text, comments, images) | No | Text provided by the user or by an integration available in the environment, used as the brainstorm (source `<tracker> <identifier>`); never fetch the tracker from this skill. Record the tracker reference in the document. | — |
| Output directory | No | User | Default `docs/discovery/`; tell the user. |
| Output file name | No | User | Derive `refinement-NNN-<topic>.md` (keep an existing numeric ID from the brainstorm; otherwise use the next free `NNN` in the output directory). |

## Preconditions

- [ ] Brainstorm (or existing refinement) is identified and fully read.
- [ ] [assets/refinement-template.md](assets/refinement-template.md) was read in full in this session.
- [ ] Output path decided; if the file already exists → ask the user whether to replace or choose another name.

## Procedure

### 1. Identify source, destination and template

1. Read the whole brainstorm; preserve title, identifier and original content. If text was pasted, record that the source is the conversation.
2. Read the template in full; use it as the mandatory structure. Do not keep a summarized copy of it elsewhere.
3. Never modify or overwrite the brainstorm file.
4. Resolve the output path (Inputs table). Create the directory if missing. Never overwrite an existing file without the user's agreement.
5. If the brainstorm is partial → proceed with the possible discovery and record gaps as questions. Never invent answers.

### 2. Discover the current project state

1. Map the workspace: list top-level folders; identify modules by build manifests (`package.json`, `pom.xml`, `build.gradle*`, `*.csproj`, `go.mod`, `pyproject.toml`).
2. Search `docs/` for architecture documents (`*architecture*.md`), specs, journeys and previous refinements related to the topic; read the relevant ones first.
3. Follow the flows into code: entry points, contracts, persistence and tests related to the topic.
4. Run focused searches for terms, symbols, endpoints, screens and concepts from the brainstorm. Read the files that support each finding.
5. Classify each finding as: **confirmed behavior**, **unconfirmed hypothesis**, **gap needing investigation**, or **recommended change**. Record evidence as relative path + symbol, test, contract or URL.
6. Declare a gap as confirmed only after inspecting the relevant entry points and implementations; otherwise record the search limits.

### 3. Research external references

1. If a web search/fetch tool is available → research practices specific to the problem, prioritizing official documentation, recognized standards and primary sources; open each source to confirm its content.
2. For each source, record: title, URL, type/authority, relevant guidance, consultation date and applicability to the project.
3. Distinguish published guidance from business decisions; explain adaptations, trade-offs and reasons for discarding a practice.
4. If no web tool is available → do not simulate research or fill references from memory. Record the limitation in "Research limitations" and list references that need confirmation. Continue with internal discovery.

### 4. Refine ideas into requirements

1. Keep a faithful transcription of the brainstorm in section 1. Do not rewrite ideas as approved decisions.
2. Fill every section and subsection of the template, in order, keeping its headings and tables.
3. For conditional content (data, integrations, migration, operations): write "Not applicable" + justification only when the analysis confirms it; if evidence is insufficient, record a pending item instead.
4. Write atomic, verifiable requirements with stable IDs: `FR-XX` (functional), `BR-XX` (business rule), `NFR-XX` (non-functional), `AC-XX` (acceptance criterion), `D-XX` (decision). Link each to its idea, evidence, source or decision.
5. Mark requirement state as `Proposed`, `Validated` or `Blocked`. Use `Validated` only with an explicit decision from the business owner; technical discovery is not client approval.
6. Write observable acceptance criteria (main scenario + relevant exceptions). Do not fabricate numeric limits; record a question when a limit depends on a missing decision or measurement.
7. Define included and out-of-scope items; record impacts and dependencies with evidence, or mark them as hypotheses.
8. Record approved decisions with owner and date; record open questions with impact, expected owner and status. Never turn a recommendation or assumption into a decision.
9. Replace every template placeholder with confirmed content, a justified "Not applicable", or a specific question/pending item.

### 5. Help resolve open decisions

1. Save the document first (Step 6.3) so the discovery is not lost if the user stops.
2. For each `D-XX` in state `Open`, prepare exactly **3** distinct, viable options. Each option has: short actionable description; grounding (discovery evidence and/or a section 4 reference); main trade-offs (effort, risk, requirements, security, data, cost, UX as applicable).
3. Mark exactly **one** option as recommended and justify it with project evidence and researched practices. Prefer the option that reuses what exists and respects the architecture documents found in Step 2.2, unless justified otherwise.
4. If an option lacks grounding → say so explicitly in its grounding field; never invent support.
5. Ask using the interactive question tool when available (e.g. `ask_user`):
   - one field per decision, titled `D-XX — <short question>`, description with context, impact and a summary of each option;
   - the 3 options as suggested values, the recommended one labeled "(Recommended)" and set as default;
   - a free-text answer allowed;
   - at most 4–5 related decisions per form; use successive forms for more, blocking ones first.
6. If no interactive tool exists → present a numbered list per decision with options `1`, `2`, `3` (recommended marked) and `4 – Other (describe)`, and wait.
7. On answers:
   - record each in "Approved Decisions" with the chosen option (or typed text), who answered, date and alternatives considered with the reason;
   - if the user skips or does not know → keep it `Open` and update owner/deadline if given;
   - if an answer is ambiguous or conflicts with another decision/requirement → ask a clarifying question before recording;
   - propagate effects to FR/BR/NFR, acceptance criteria, scope and risks. Set requirements to `Validated` only when the respondent is (or confirms approval from) the business owner.
8. If answers raise new blocking doubts → record new `D-XX` and repeat this step only if the user wants to continue.

### 6. Determine readiness and save

1. Mark `Ready for specification` only if goal, flow, verifiable requirements, acceptance criteria and scope are clear and no blocking business decision remains.
2. Otherwise mark `Blocked by discovery`, list concrete blockers and who must answer them. Still create the document with the available evidence.
3. Save the file at the resolved path. Do not change the brainstorm or start specification, plan, backlog or implementation.
4. Verify Done Criteria.

## Rules

### MUST

- Preserve the original brainstorm.
- Cite paths, symbols, tests, contracts or URLs for every finding.
- Separate project facts, external sources, client decisions, recommendations, hypotheses and open questions.
- Ask objective questions whenever an answer affects scope, business rules, security, data or acceptance criteria.
- Consider error cases, authorization, compatibility and operations as the topic requires; mark explicitly what does not apply.

### MUST NOT

- Change application code.
- Invent URLs, sources, statistics, legal requirements or market consensus.
- Present an isolated recommendation as universal practice.
- Fill gaps with assumptions or mark requirements `Validated` without the business owner.
- Overwrite existing files without the user's agreement.
- Leave generic placeholders without context.

## Resources

| File | When to read |
|---|---|
| [assets/refinement-template.md](assets/refinement-template.md) | Always, in full, before writing (Step 1.2). |

## Output

- One refinement file following the template in full (default `docs/discovery/refinement-NNN-<topic>.md`).
- Final message: path used, main project findings, external references consulted (or the research limitation), decisions answered in this session (with the chosen option) and decisions still blocking specification.
- Output language: English.

## Done Criteria

- [ ] All template sections kept, in order.
- [ ] Every finding has traceable evidence; every reference has URL and date (or the limitation is recorded).
- [ ] No generic placeholders remain.
- [ ] Every open decision has 3 grounded options with one recommended.
- [ ] Readiness status matches the recorded blockers.
- [ ] Brainstorm file unchanged; no application code changed.
