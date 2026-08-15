---
id: {{change-base-name}}-tasks
title: {{human-readable title}} Tasks
status: pending
index_approved: false
spec: .redline/project/specs/{{change-base-name}}/{{change-base-name}}.spec.md
plan: .redline/project/specs/{{change-base-name}}/plan/{{change-base-name}}.plan.md
---

# {{title}} Tasks

## Summary

- **Total Phases:** {{number}}
- **Total Tasks:** {{number}}
- **Execution Model:** Phases run sequentially. Inside each phase, the `Execution Tree` defines order and parallelization.
- **Index Approval:** `index_approved` must be `true` before generating task files.

## Vertical Slice Map

Briefly explain how the implementation is divided into vertical phases.

- **P01:** {{functional slice delivered by phase 1}}
- **P02:** {{functional slice delivered by phase 2}}
- **P03:** {{functional slice delivered by phase 3}}

## Phases

### P01. {{Phase title}}

**Status:** pending

#### Functional Slice

{{Describe the minimum functional result this phase delivers.}}

#### Scope

- {{What this phase includes}}
- {{What this phase includes}}

#### Out of Scope

- {{What this phase explicitly does not include}}
- {{What this phase explicitly does not include}}

<!-- Omit only if no useful out-of-scope exists. -->

#### Functional Verification

{{Describe how this vertical slice can be functionally verified. This can be manual, technical, or both depending on the change.}}

#### Execution Tree

```
P01-T01  {{task summary}} (root)
├── [∥] P01-T02  {{task summary}}
├── [∥] P01-T03  {{task summary}}
└── P01-T04  {{task summary}}
    └── P01-T05  {{task summary}}
```

<!-- Write the tree in filesystem style: put the root task first, indent every child under its parent using ├── / └── / │, and mark every parallelizable sibling group with [∥]. -->

#### Tasks

| Task | Type | Status | File | Contract Summary |
| --- | --- | --- | --- | --- |
| P01-T01 | implementation | pending | phase-01-task-01-{{slug}}.task.md | {{Short contract summary}} |
| P01-T02 | implementation | pending | phase-01-task-02-{{slug}}.task.md | {{Short contract summary}} |
| P01-T03 | test | pending | phase-01-task-03-{{slug}}.task.md | {{Short contract summary}} |
| P01-T04 | implementation | pending | phase-01-task-04-{{slug}}.task.md | {{Short contract summary}} |
| P01-T05 | verification | pending | phase-01-task-05-{{slug}}.task.md | {{Short contract summary}} |

<!-- Keep this table as the status panel; task IDs and filenames must match the tree above. -->

### P02. {{Phase title}}

**Status:** pending

#### Functional Slice

{{Describe the minimum functional result this phase delivers.}}

#### Scope

- {{What this phase includes}}

#### Functional Verification

{{Describe how this vertical slice can be functionally verified.}}

#### Execution Tree

```
P02-T01  {{task summary}} (root)
├── [∥] P02-T02  {{task summary}}
└── [∥] P02-T03  {{task summary}}
```

#### Tasks

| Task | Type | Status | File | Contract Summary |
| --- | --- | --- | --- | --- |
| P02-T01 | implementation | pending | phase-02-task-01-{{slug}}.task.md | {{Short contract summary}} |
| P02-T02 | implementation | pending | phase-02-task-02-{{slug}}.task.md | {{Short contract summary}} |
| P02-T03 | test | pending | phase-02-task-03-{{slug}}.task.md | {{Short contract summary}} |

## Rules Referenced

- `.redline/project/rules/{{rule-name}}.rule.md` - {{Rule title}}
- `.redline/project/rules/{{rule-name}}.rule.md` - {{Rule title}}

<!-- The index references rules only. Individual task files expand relevant rules. -->

## Open Questions

<!-- Present only when status: blocked. -->

- {{Question blocking vertical slicing or task generation}}
