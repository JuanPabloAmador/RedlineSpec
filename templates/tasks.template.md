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
- **Execution Model:** Sequential by default. Tasks may run in parallel only when consecutive tasks declare the same `parallel_group` in this index.
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

#### Tasks

| Task | Type | Status | File | Parallel Group | Contract Summary |
| --- | --- | --- | --- | --- | --- |
| P01-T01 | test | pending | phase-01-task-01-{{slug}}.task.md |  | {{Short contract summary}} |
| P01-T02 | implementation | pending | phase-01-task-02-{{slug}}.task.md | P01-G1 | {{Short contract summary}} |
| P01-T03 | implementation | pending | phase-01-task-03-{{slug}}.task.md | P01-G1 | {{Short contract summary}} |
| P01-T04 | verification | pending | phase-01-task-04-{{slug}}.task.md |  | {{Short contract summary}} |

### P02. {{Phase title}}

**Status:** pending

#### Functional Slice

{{Describe the minimum functional result this phase delivers.}}

#### Scope

- {{What this phase includes}}

#### Functional Verification

{{Describe how this vertical slice can be functionally verified.}}

#### Tasks

| Task | Type | Status | File | Parallel Group | Contract Summary |
| --- | --- | --- | --- | --- | --- |
| P02-T01 | test | pending | phase-02-task-01-{{slug}}.task.md |  | {{Short contract summary}} |
| P02-T02 | implementation | pending | phase-02-task-02-{{slug}}.task.md |  | {{Short contract summary}} |

## Functional Coverage

| Spec Reference | Covered By Phase | Covered By Tasks | Notes |
| --- | --- | --- | --- |
| FB-1 / FR-1.1 | P01 | P01-T01, P01-T02 | {{coverage note}} |
| FB-1 / FR-1.2 | P02 | P02-T01, P02-T02 | {{coverage note}} |

## Technical Coverage

| Plan Reference | Covered By Phase | Covered By Tasks | Notes |
| --- | --- | --- | --- |
| TB-1 / {{technical unit}} | P01 | P01-T02 | {{coverage note}} |
| TB-2 / {{technical unit}} | P02 | P02-T02 | {{coverage note}} |

## Rules Referenced

- `.redline/project/rules/{{rule-name}}.rule.md` - {{Rule title}}
- `.redline/project/rules/{{rule-name}}.rule.md` - {{Rule title}}

<!-- The index references rules only. Individual task files expand relevant rules. -->

## Open Questions

<!-- Present only when status: blocked. -->

- {{Question blocking vertical slicing or task generation}}
