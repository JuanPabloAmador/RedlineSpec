---
id: {{TU-01}}
title: {{Technical unit title}}
status: draft
spec: .redline/project/specs/{{change-base-name}}/{{change-base-name}}.spec.md
plan: .redline/project/specs/{{change-base-name}}/plan/{{change-base-name}}.plan.md
block: {{TB-1}}
type: component | service | endpoint | controller | repository | model | module | hook | utility | other
---

# {{Technical unit title}}

## Source Trace

### Spec

- `.redline/project/specs/{{change-base-name}}/{{change-base-name}}.spec.md`
- {{FB/FR references addressed by this unit}}

### Plan Index

- `.redline/project/specs/{{change-base-name}}/plan/{{change-base-name}}.plan.md`
- {{TB reference}}

### Rules

- `.redline/project/rules/{{rule-name}}.rule.md`
- `.redline/project/rules/{{rule-name}}.rule.md`

## Responsibility

{{Describe what this technical unit is responsible for.}}

## Affected Artifacts

### Existing Artifacts

- `{{path/to/existing-file-or-area}}`
- `{{path/to/existing-file-or-area}}`

### New Artifacts

- `{{expected/path/to/new-file}}`
- `{{allowed/path/pattern/**}}`

<!-- Use `None.` for either subsection when appropriate. -->

## Inputs

- {{Input shape / source / type}}
- {{Input shape / source / type}}

## Outputs

- {{Output shape / effect / type}}
- {{Output shape / effect / type}}

## Dependencies

- {{Injected dependency or collaborator}}
- {{Imported module or package dependency}}

## Public Surface

- `{{public signature}}`
- `{{public signature}}`

## Key Internal Functions

- `{{internal signature}}`
- `{{internal signature}}`

## Contract Shapes

```ts
{{signature, schema, DTO, event, props, return type, or other implementation-constraining shape}}
```

## Relevant Rules

### `.redline/project/rules/{{rule-name}}.rule.md`

{{Rule reference or concise relevant constraint for this unit.}}

If no rules apply:

```txt
None.
```

## Supporting Context

<!-- Include only if needed. -->

- [{{path-to-supporting-context.md}}]({{path-to-supporting-context.md}}) — {{What this context document is for}}

## Open Questions

<!-- Omit if not applicable. If any open question remains, status should stay draft. -->

- {{Open technical question local to this unit}}
