---
doc: tasks
feature: {{feature name}}
status: draft
depends_on: [plan.md, spec.md]
architecture_ref: {{same value as in spec.md}}
generated_by: spec-kit-3-tasks
---

# Tasks — {{Feature Name}}

<!--
Mandatory task format (one action per task):

- [ ] X.Y - Task name
Description: {{what to do}}
Architecture/Implementation: {{layer/pattern/convention, grounded in architecture_ref}}
Input: {{spec.md#section reference, if any}}
Output: {{file/artifact to create or change}}
Test scenarios: {{if any}}
Acceptance criteria: {{measurable, traceable to the spec.md AC-XX}}

X = Phase number (same order as plan.md); Y = sequence within the phase.

Execution protocol: see spec-kit-executor. When a task is finished: "- [x]", add "Comment:",
open pending items as nested sub-tasks "- [ ] X.Y.N - ...".
-->

## Phase 1 — {{phase name, identical to plan.md}}

- [ ] 1.1 - {{task name}}
Description: {{...}}
Architecture/Implementation: {{...}}
Input: {{...}}
Output: {{...}}
Test scenarios: {{...}}
Acceptance criteria: {{...}}

## Phase 2 — {{phase name, identical to plan.md}}

- [ ] 2.1 - {{task name}}
Description: {{...}}
Architecture/Implementation: {{...}}
Input: {{...}}
Output: {{...}}
Test scenarios: {{...}}
Acceptance criteria: {{...}}
