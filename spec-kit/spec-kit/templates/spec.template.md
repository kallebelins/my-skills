---
doc: spec
feature: {{feature name}}
status: draft
architecture_ref: {{path of the resolved architecture document, or "agreed with the user: <short description>"}}
generated_by: spec-kit-1-specify
---

# Spec — {{Feature Name}}

## Sources
- {{description given in the conversation and/or path of each context file read}}

## Scope Summary
<!-- Capability groups covered by this spec. The phases in plan.md MUST map 1:1 to this list. -->
1. {{capability group 1}}
2. {{capability group 2}}

## Out of Scope
- {{explicitly excluded items — plan.md copies these items verbatim}}

## Business Rules
<!-- Consolidate every rule from the sources. Do not summarize to the point of losing rules. One rule per item. -->
- BR-01: {{...}}

<!-- Only when applicable: endpoints, components, integrations. Otherwise, remove the section. -->
## Contracts
### {{Endpoint/component name}}
- {{method/route or selector}}
- Request/Props: {{...}}
- Response/Emits: {{...}}

<!-- Only when applicable. Otherwise, remove the section. -->
## Data Models
| Field | Type | Validation | Source |
|---|---|---|---|
| {{...}} | {{...}} | {{...}} | {{...}} |

## Edge Cases
- {{...}}

## Error Handling
- {{...}}

## Acceptance Criteria (measurable)
- AC-01: {{each criterion must be individually referenceable by a task in tasks.md}}

## Open Questions
<!-- Gaps that block a measurable criterion — ask the user instead of assuming. Remove the section when empty. -->
- {{...}}
