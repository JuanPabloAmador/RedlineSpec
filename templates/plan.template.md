---
id: {{change-base-name}}
title: {{human-readable title}}
status: draft
spec: .redline/project/specs/{{change-base-name}}/{{change-base-name}}.spec.md
---

# {{title}}

## Affected Areas

### Existing Areas to Change

#### UI
- {{Existing UI area to change}}

#### Server
- {{Existing server area to change}}

<!-- Group by the technical domains that actually apply. Omit unused domains. -->

### New Artifacts to Create

#### UI
- {{New UI artifact area to create}}

#### Server
- {{New server artifact area to create}}

<!-- Group by the technical domains that actually apply. Omit unused domains. -->

## Plan-Wide Context

<!-- Omit this entire section if no plan-wide context is needed. -->

### Shared Decisions

- {{Decision that applies across multiple technical blocks or units}}
- {{Decision that applies across multiple technical blocks or units}}

<!-- Omit if not applicable. -->

### Open Questions

- {{Open technical question affecting multiple technical blocks or units}}
- {{Open technical question affecting multiple technical blocks or units}}

<!-- Omit if not applicable. If any open question remains, status should stay draft. -->

### Rules

- `.redline/project/rules/{{domain-rule-name}}.rule.md` — {{Rule title}}
- `.redline/project/rules/{{domain-rule-name}}.rule.md` — {{Rule title}}

<!-- Omit if not applicable. -->

### Supporting Context

- [{{path-to-supporting-context.md}}]({{path-to-supporting-context.md}}) — {{What this context document is for}}
- [{{path-to-supporting-context.md}}]({{path-to-supporting-context.md}}) — {{What this context document is for}}

<!-- Omit if not applicable. -->

## Technical Blocks

### TB-1. {{Block title}}

**Change Type:** add | modify | remove

#### Affected Areas

- {{UI | Server | Model | API | Shared | Database | Other}}
- {{UI | Server | Model | API | Shared | Database | Other}}

#### Resolves

- FB-1
- FB-2

#### Artifacts

- {{Conceptual code artifact affected or created by this block}}
- {{Conceptual code artifact affected or created by this block}}

#### Responsibility

{{Describe the technical responsibility of this block as a coherent implementation unit.}}

#### Technical Units

| Unit | Type | File | Contract Summary |
| --- | --- | --- | --- |
| TU-01 | component | technical-units/tu-01-{{slug}}.plan.md | {{Short technical unit contract summary}} |
| TU-02 | service | technical-units/tu-02-{{slug}}.plan.md | {{Short technical unit contract summary}} |

#### Open Questions

- {{Open technical question local to this block}}
- {{Open technical question local to this block}}

<!-- Omit if not applicable. If any open question remains, status should stay draft. -->

#### Rules

- `.redline/project/rules/{{domain-rule-name}}.rule.md` — {{Rule title}}
- `.redline/project/rules/{{domain-rule-name}}.rule.md` — {{Rule title}}

<!-- This subsection is mandatory in every block. Use `- None.` when no block-specific rule applies beyond plan-wide context. -->

#### Supporting Context

- [{{path-to-supporting-context.md}}]({{path-to-supporting-context.md}}) — {{What this context document is for}}
- [{{path-to-supporting-context.md}}]({{path-to-supporting-context.md}}) — {{What this context document is for}}

<!-- Omit if not applicable. -->

### TB-2. {{Block title}}

**Change Type:** add | modify | remove

#### Affected Areas

- {{UI | Server | Model | API | Shared | Database | Other}}

#### Resolves

- FB-3

#### Artifacts

- {{Conceptual code artifact affected or created by this block}}

#### Responsibility

{{Describe the technical responsibility of this block as a coherent implementation unit.}}

#### Technical Units

| Unit | Type | File | Contract Summary |
| --- | --- | --- | --- |
| TU-03 | endpoint | technical-units/tu-03-{{slug}}.plan.md | {{Short technical unit contract summary}} |

#### Rules

- None.
