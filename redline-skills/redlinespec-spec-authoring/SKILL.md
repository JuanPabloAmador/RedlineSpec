---
name: redlinespec-spec-authoring
description: Create and refine RedlineSpec functional change specs using the official spec template. Use when drafting a *.spec.md from interviews or validating it for readiness.
---

# RedlineSpec Spec Authoring

Use this skill when the task is to create, refine, or review a RedlineSpec `*.spec.md` file before implementation.

Before writing or updating any spec, read the official template:

- `.redline/system/templates/spec.template.md`

Treat that template as canonical shape. This skill teaches how to fill it correctly.

Template resolution is installation-relative: locate the target project root that contains `.redline/system/templates/`, then read templates from that directory. If `.redline/system/templates/spec.template.md` is missing, stop and report that the RedlineSpec system installation is incomplete or must be refreshed.

## Purpose

A RedlineSpec `Spec` is a temporary functional contract for a change.

It exists to:

- define the functional delta from current functional truth,
- guide the next phase without requiring the whole conversation history,
- remain readable for humans,
- remain structured for agents,
- and later be closed by the implementation/finalization workflow so it can drive functional consolidation.

A `Spec` is not a technical design document.

## Core Rules

Always follow these rules:

1. Keep the spec functional, not technical.
2. Make it structured for agents and readable for humans.
3. Focus on the desired change; include current functional context only when needed to explain it.
4. Do not allow unresolved functional ambiguity to pass forward.
5. Implementation freedom is allowed; functional ambiguity is not.
6. Use the exact section names and overall shape from `.redline/system/templates/spec.template.md`.
7. Omit conditional sections when they do not apply.
8. Use real file paths in `based_on` and `affects`.
9. The spec must stay in English.
10. Functional truth may only be taken from `.redline/project/functional-truth/functional.index.md`, `.redline/project/functional-truth/*.entry.md`, and `.redline/project/functional-truth/*.global.entry.md`.
11. If no official functional truth files exist yet, warn explicitly and continue with `based_on: []` and `affects: []`.

## File Naming and Identity

Write the spec at `.redline/project/specs/<change>/<change>.spec.md`.

The change base name should be based on the functional area and, when needed, the concrete change.

Examples:

- `.redline/project/specs/checkout/checkout.spec.md`
- `.redline/project/specs/checkout-guest-flow/checkout-guest-flow.spec.md`
- `.redline/project/specs/profile-email-verification/profile-email-verification.spec.md`

Rules:

- `id` must derive from the change base name.
- Do not use sequential IDs like `spec-001`.
- Prefer names that stay meaningful even if specs are created or merged out of order.

## Status Model

Allowed values:

- `draft`
- `ready`
- `implemented`

Meaning:

### `draft`

Use when the spec is still being shaped and there are open functional decisions.

Rules:

- `Pending to Reach Ready` must be present.
- It should list only real unresolved functional decisions.
- An agent must not suggest `ready` if functional decisions are still unresolved.

### `ready`

Use when the human decides the functional contract is sufficiently closed.

Rules:

- `Pending to Reach Ready` must be removed.
- No unresolved functional ambiguity should remain.
- The spec is ready for the next workflow step, whether that is planning or direct implementation.

### `implemented`

Do not set this status from this authoring workflow. Use it only when the implementation/finalization workflow has closed the spec after implementation.

Rules:

- `Implemented Result` must exist.
- `Implementation Summary` must exist.
- `Relevant Differences from Proposed Change` must exist.
- `Impact on Functional Truth` must exist.
- `affects` must reflect the real final impacted functional documents.

## Frontmatter Rules

The frontmatter is mandatory and must contain exactly these contract fields:

```yaml
---
id: {{change-base-name}}
title: {{human-readable title}}
status: draft
based_on:
  - .redline/project/functional-truth/functional.index.md
  - .redline/project/functional-truth/{{relevant-functional-document.md}}
affects:
  - .redline/project/functional-truth/{{affected-functional-document.md}}
---
```

Rules:

- `title` is required and human-readable.
- `based_on` lists existing official functional truth documents used as base.
- `affects` lists official functional truth documents impacted by the change.
- If no official functional truth exists yet, use `based_on: []` and `affects: []`.
- Use real repository paths or file names, not logical aliases.

## Required Macro Structure

The spec body must always keep these main sections in this order:

1. `Problem`
2. `Objective`
3. `Out of Scope`
4. `Functional Blocks`

Conditional sections:

- `Pending to Reach Ready` only in `draft`
- `Global Constraints and Conditions` only if applicable
- `Implemented Result` only in `implemented`

Rules:

- `Problem` and `Objective` must always exist as sections.
- `Out of Scope` must always exist as a guard against overreach.
- If `Problem` or `Objective` is not truly applicable, use `Implicit` or `N/A`.
- Do not invent filler just to satisfy a section.
- Keep detailed functional behavior in `Functional Blocks`, not in the macro sections.

## Functional Blocks

Functional blocks are the main unit of the contract.

Each block must:

- have an ID like `FB-1`, `FB-2`,
- have a clear title,
- declare `Change Type: add | modify | remove`,
- include `Requirements`,
- include `Acceptance Criteria`.

Example shape:

```md
### FB-1. Block title

**Change Type:** add | modify | remove

#### Requirements

- FR-1.1 Verifiable functional requirement
- FR-1.2 Verifiable functional requirement

#### Acceptance Criteria

- Block-level acceptance criterion
- Block-level acceptance criterion
```

### Requirement Rules

- Requirements must be functional.
- Requirements must be verifiable.
- Requirements must be numbered hierarchically as `FR-1.1`, `FR-1.2`, `FR-2.1`, etc.
- Do not mix technical design decisions into requirements.

### Conditional Block Subsections

These subsections are allowed, but only when needed:

- `Functional References`
- `Context Needed`
- `Block Constraints and Conditions`
- `Key Scenarios`

Rules:

#### `Functional References`

Use when the block should point the reader to specific official functional truth documents to understand the change better.

#### `Context Needed`

Use only for the minimum existing functional context required to understand the block.

#### `Block Constraints and Conditions`

Use for constraints specific to that block.

#### `Key Scenarios`

Use only when scenarios help clarify expected behavior.

Important:

- `Key Scenarios` do not have IDs.
- `Acceptance Criteria` do not have IDs.
- Criteria are defined at block level, not per requirement.

## Constraints

Use `Global Constraints and Conditions` only when a rule affects the entire spec.

Examples:

- rollout limitations visible at functional level,
- compatibility constraints visible to users or operators,
- business rules that apply across multiple blocks,
- audit or permission constraints that shape the whole change.

If a constraint applies only to one block, keep it in that block instead.

## Implemented Result

Only add this section when `status: implemented`.

Its purpose is not to restate the whole spec. Its purpose is to close the contract with the real result.

Use this structure:

```md
## Implemented Result

### Implementation Summary

### Relevant Differences from Proposed Change

### Impact on Functional Truth
- .redline/project/functional-truth/functional.index.md
- .redline/project/functional-truth/impacted.entry.md
```

Rules:

- `Implementation Summary` explains what was actually delivered.
- `Relevant Differences from Proposed Change` captures only meaningful deviations.
- `Impact on Functional Truth` lists the impacted functional truth files only.
- Do not write explicit edit instructions like `create`, `update`, or `remove` there.
- The consolidation workflow is responsible for interpreting the final spec and applying the merge.

## Authoring Workflow

When asked to write or update a spec, follow this process:

1. Read `.redline/system/templates/spec.template.md`.
2. Inspect relevant official functional truth files referenced by the task.
3. Determine the correct change base name and target spec path, and derive `id` from that change base name.
4. Fill the frontmatter.
5. Write `Problem`, `Objective`, and `Out of Scope`.
6. If status is `draft`, include `Pending to Reach Ready`.
7. Add `Global Constraints and Conditions` only if they affect the whole spec.
8. Break the change into `Functional Blocks`.
9. For each block, add only the conditional subsections that materially improve clarity.
10. Make every requirement functional and verifiable.
11. Make every acceptance criterion observable at block level.
12. If status is `implemented`, add `Implemented Result`; final `affects` updates belong to the implementation/finalization workflow.
13. Before saving, validate the document against the checklist below.

## Validation Checklist

Before finishing, verify all of the following:

- The file follows `*.spec.md` naming.
- `id` matches the change base name.
- The document is fully in English.
- The spec is functional, not technical.
- `based_on` and `affects` use real paths to official functional truth files, or `[]` when no official functional truth exists yet.
- Main sections appear in the correct order.
- Macro sections do not restate detailed behavior that belongs in `Functional Blocks`.
- Conditional sections are omitted when not applicable.
- If status is `draft`, `Pending to Reach Ready` exists.
- If status is `ready`, there are no unresolved functional decisions.
- If status is `implemented`, `Implemented Result` exists.
- Every functional block has a block ID and change type.
- Every block has numbered requirements.
- Every block has acceptance criteria.
- No scenarios or acceptance criteria use formal IDs.
- No unresolved functional ambiguity remains unless the status is still `draft`.

## What Not To Do

Do not:

- turn the spec into a technical implementation plan,
- include architecture, module design, APIs, or code-level solution detail unless the user explicitly asks for a different artifact,
- duplicate large parts of existing functional truth without need,
- leave functional intent implicit when it should be explicit,
- mark a spec as `ready` while open functional decisions remain,
- keep `Pending to Reach Ready` once the spec is no longer `draft`,
- add explicit merge instructions in `Impact on Functional Truth`.

## Output Behavior

When using this skill, produce specs that are:

- contract-shaped,
- concise,
- verifiable,
- easy to merge back into functional truth,
- and faithful to `.redline/system/templates/spec.template.md`.
