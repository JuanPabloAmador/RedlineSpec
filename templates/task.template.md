---
id: {{P01-T01}}
title: {{Task title}}
status: pending
contract_ready: false
phase: {{P01}}
type: test | implementation | migration | refactor | verification | documentation | other
spec: .redline/project/specs/{{change-base-name}}/{{change-base-name}}.spec.md
plan: .redline/project/specs/{{change-base-name}}/plan/{{change-base-name}}.plan.md
---

# {{Task title}}

## Source Trace

### Spec

- `.redline/project/specs/{{change-base-name}}/{{change-base-name}}.spec.md`
- {{FB/FR references used by this task}}

### Plan

- `.redline/project/specs/{{change-base-name}}/plan/{{change-base-name}}.plan.md`
- {{TB references}}
- {{Technical unit references}}

### Rules

- `.redline/project/rules/{{rule-name}}.rule.md`
- `.redline/project/rules/{{rule-name}}.rule.md`

<!-- List source rules here. Expand relevant rule content in `Relevant Rules`. -->

## Task Contract

{{Describe the task's concrete responsibility inside the phase.}}

## Change Scope

### Existing Artifacts Allowed to Change

- `{{path/to/existing-file}}`
- `{{path/to/existing-area-or-module}}`

### New Artifacts Allowed to Create

- `{{expected/path/to/new-file}}`
- `{{allowed/path/pattern/**}}`

### Out of Scope

- {{Only include when useful to prevent confusion or overreach}}

<!-- Omit if not applicable. -->

## Acceptance Contract

- {{Local requirement or expected result for this task, including how it is validated.}}
- {{Local requirement or expected result for this task, including how it is validated.}}
- {{No-regression criterion, if applicable.}}

<!-- This section combines acceptance and verification. A task can only become `done` if this contract is satisfied. -->

## Contract Shapes

{{Define the signatures, shapes, public surfaces, inputs, outputs, or data contracts this task must respect or create.}}

Examples:

```ts
{{signature or shape}}
```

If no shape/signature applies:

```txt
N/A - {{brief justification}}
```

## Relevant Rules

### `.redline/project/rules/{{rule-name}}.rule.md`

{{Expanded relevant rule content or concise extract needed for this task.}}

If no rules apply:

```txt
None.
```

## Repository Context

<!-- Include only if needed. -->

- {{Existing repository pattern, convention, or file relationship needed to execute this task correctly.}}
- {{Relevant local context that avoids rediscovery.}}

## Blocked Protocol

Stop and report if any of these occur:

- The task requires changing functional behavior outside its phase contract.
- The task requires changing public signatures, shapes, or architecture beyond `Contract Shapes`.
- The task needs files or areas outside `Change Scope`.
- The expected artifact path/pattern is invalid for this repository.
- The task cannot satisfy `Acceptance Contract`.
- The implementation reveals that the Plan or task contract is wrong or incomplete.

When blocked, report:

- blocking reason,
- affected contract section,
- relevant files or artifacts,
- available options,
- recommended option.
