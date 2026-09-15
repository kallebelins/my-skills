---
doc: tasks
feature: {{feature name}}
status: draft
depends_on: [plan.md, spec.md]
generated_by: spec-kit
---

# Tasks — {{Feature Name}}

<!--
Mandatory task format (one action per task):

- [ ] X.X - Task name
Description: {{what to do}}
Architecture/Implementation: {{layer/pattern/convention, based on the resolved architecture reference (docs/architecture.md or pattern agreed with the user)}}
Input: {{reference to spec.md#..., if any}}
Output: {{artifact/file to create or modify}}
Test scenarios: {{if any}}
Acceptance criteria: {{measurable, traceable to spec.md}}

X = Phase number (same order as plan.md), X.X = sequence within the phase.

Execution protocol (spec-kit-tasks/SKILL.md): when completing a task, mark "- [x]", add
a "Comment:" line with what was done and, if there is pending work, create sub-task(s)
"- [ ] X.X.N - ..." nested under the parent task. When all tasks in a phase are
"[x]", also check off the phase checkbox in plan.md.
-->

## Phase 1 — {{phase name, same as plan.md}}

- [ ] 1.1 - {{task name}}
Description: {{...}}
Architecture/Implementation: {{...}}
Input: {{...}}
Output: {{...}}
Test scenarios: {{...}}
Acceptance criteria: {{...}}

## Phase 2 — {{phase name, same as plan.md}}

- [ ] 2.1 - {{task name}}
Description: {{...}}
Architecture/Implementation: {{...}}
Input: {{...}}
Output: {{...}}
Test scenarios: {{...}}
Acceptance criteria: {{...}}
