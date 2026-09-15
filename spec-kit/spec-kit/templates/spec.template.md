---
doc: spec
feature: {{feature name}}
status: draft
architecture_ref: {{docs/architecture.md or pattern agreed with the user}}
generated_by: spec-kit
---

# Spec — {{Feature Name}}

## Sources
- {{description provided in the conversation and/or path to the context file read}}

## Scope Summary
<!-- Enumerate the capability groups this spec covers. plan.md phases MUST map 1:1 to this list. -->
1. {{capability group 1}}
2. {{capability group 2}}

## Out of Scope
- {{explicitly excluded items — plan.md will copy these verbatim}}

## Business Rules
<!-- Consolidate as much as possible from the sources above. Do not summarize to the point of losing rules. -->
- {{...}}

<!-- Only when applicable: endpoints, components, integrations -->
## Contracts
### {{Endpoint/component name}}
- {{method/route or selector}}
- Request/Props: {{...}}
- Response/Emits: {{...}}

<!-- Only when applicable -->
## Data Models
| Field | Type | Validation | Source |
|---|---|---|---|
| {{...}} | {{...}} | {{...}} | {{...}} |

## Edge Cases
- {{...}}

## Error Handling
- {{...}}

## Acceptance Criteria (measurable)
- {{each criterion must be individually referenceable by a task in tasks.md}}

## Open Questions
<!-- Gaps that block a measurable criterion — ask the user instead of inventing. Remove the section if empty. -->
- {{...}}
