---
name: write-spec
description: Execute the RedlineSpec /write-spec workflow. Use when context has already been gathered, or when you need to finish gathering the minimum missing context and then write a complete *.spec.md using the official RedlineSpec spec template.
---

# RedlineSpec /write-spec Workflow

Use this skill to execute the operational workflow for writing a RedlineSpec `*.spec.md`.

This is a workflow skill, not just a style guide.

It tells you what to do, in what order, and when to stop asking questions and write the file.

## Read First

Before doing anything else, read these files:

- `.redline/system/templates/spec.template.md`

If the task context mentions current functional truth files, also read those files before drafting the spec.

This workflow must be portable. Do not depend on framework docs outside the distributed skills and templates. The only framework artifact you should need at runtime is the official template plus the rules embedded in this skill.

Template resolution is installation-relative: locate the target project root that contains `.redline/system/templates/`, then read templates from that directory. If `.redline/system/templates/spec.template.md` is missing, stop and report that the RedlineSpec system installation is incomplete or must be refreshed.

## Purpose of /write-spec

`/write-spec` exists to turn already-gathered context into a formal RedlineSpec functional contract.

Its expected result is:

- one complete `*.spec.md`,
- written from the official template,
- functionally clear,
- ready to serve as the next contract in the flow.

The spec is the minimum mandatory contract for any change that modifies functional truth.

A RedlineSpec `Spec` is a temporary functional contract. It defines the change as a branch from current functional truth, then later can be updated with the real implemented result so it can drive consolidation back into functional truth.

## Embedded Contract Rules

This workflow is self-sufficient. Do not rely on any other skill to know how a RedlineSpec spec works.

Always apply these rules:

1. Keep the spec functional, not technical.
2. Make it structured for agents and readable for humans.
3. Focus on the desired change; include existing functional context only when needed to explain it.
4. Do not allow unresolved functional ambiguity to pass forward.
5. Implementation freedom is allowed; functional ambiguity is not.
6. Use the exact section names and overall shape from `.redline/system/templates/spec.template.md`.
7. Omit conditional sections when they do not apply.
8. Use real repository file paths or file names in `based_on` and `affects`, not logical aliases.
9. Keep the entire spec in English.
10. Do not duplicate large parts of existing functional truth unless they are needed to explain the change.
11. Do not turn the spec into a technical plan.
12. Functional truth may only be taken from `.redline/project/functional-truth/functional.index.md`, `.redline/project/functional-truth/*.entry.md`, and `.redline/project/functional-truth/*.global.entry.md`.
13. If no official functional truth files exist yet, warn explicitly and continue with `based_on: []` and `affects: []`.

## When To Use This Skill

Use this skill when:

- the user wants to create a new RedlineSpec spec,
- the user says `/write-spec`,
- the task is to formalize a functional change after interview/context gathering,
- the user has already discussed the change and now wants the spec written,
- or an existing draft spec must be completed or refined into a valid RedlineSpec contract.

## Preconditions

This workflow assumes there is already enough context to write the spec.

That context may come from:

- an interview with the human,
- existing functional truth,
- existing draft notes,
- or a previous conversation.

If enough context is not yet available, do not guess.

Instead:

1. identify the missing functional information,
2. ask only the necessary follow-up questions,
3. ask one question at a time,
4. keep questions focused on problem, objective, scope, constraints, and open functional decisions,
5. then continue the workflow.

If a dedicated interview workflow is available, follow it. Otherwise behave in the same spirit.

## Non-Goals

Do not use this workflow to:

- produce a technical plan,
- design architecture,
- define modules, classes, APIs, or signatures,
- write tasks,
- or implement code.

If the user actually needs a technical artifact, that belongs to `/write-plan` or `/write-tasks`, not `/write-spec`.

## Decision Gate: Should There Be a Spec?

Before drafting, determine whether the change belongs in the RedlineSpec change flow.

Ask yourself:

> Does this change modify existing functional truth or add new functional truth?

If the answer is no:

- say clearly that the change can be handled outside the RedlineSpec change flow,
- do not force a spec unless the user still explicitly wants one.

If the answer is yes:

- continue and write the spec.

This includes functional behavior, user-visible outcomes, permissions, states, flows, business rules, or any other repository truth about what the system does.

## Workflow

Follow this sequence.

### Step 1: Load the contract shape

Read:

- `.redline/system/templates/spec.template.md`

Treat the template and the rules embedded in this skill as canonical.

### Step 2: Load the functional base

Read the current functional truth documents relevant to the change.

Official functional truth can only come from:

- `.redline/project/functional-truth/functional.index.md`
- `.redline/project/functional-truth/*.entry.md`
- `.redline/project/functional-truth/*.global.entry.md`

At minimum, read the files the user mentions or the files likely to belong in:

- `based_on`
- `affects`

Do not invent these blindly if the repo can tell you the right answer.

If no official functional truth files exist yet:

- warn clearly that no official functional truth is currently documented,
- continue if the user still wants the spec written,
- use `based_on: []`,
- use `affects: []` until real official functional truth files exist or can be named confidently.

### Step 3: Check whether functional context is sufficient

You need enough information to write:

- `Problem`
- `Objective`
- `Out of Scope`
- at least one functional block with verifiable requirements and acceptance criteria

You must also be able to say, without functional ambiguity:

- what the change is,
- what it does,
- what is explicitly out of scope,
- and what parts of functional truth it relates to.

If any of that is missing, ask focused follow-up questions before writing.

### Step 4: Determine file identity

Choose a change base name and write the spec at:

- `.redline/project/specs/<change>/<change>.spec.md`

Rules:

- base `<change>` on the functional area,
- add the concrete change when needed for clarity,
- avoid sequential numbering,
- derive `id` from the change base name.

Examples:

- `.redline/project/specs/checkout/checkout.spec.md`
- `.redline/project/specs/checkout-guest-flow/checkout-guest-flow.spec.md`
- `.redline/project/specs/profile-email-verification/profile-email-verification.spec.md`

### Step 5: Decide initial status

Use:

- `draft` if functional decisions remain open,
- `ready` if the human has closed the functional contract sufficiently,
- do not use `implemented` in this workflow; implementation/finalization is responsible for closing specs after code changes.

Rules:

- do not suggest `ready` while unresolved functional decisions remain,
- the human is the final editorial authority on readiness,
- if status is `draft`, include `Pending to Reach Ready`,
- if status is `ready`, omit `Pending to Reach Ready`.

### Step 6: Fill frontmatter

The frontmatter must include:

- `id`
- `title`
- `status`
- `based_on`
- `affects`

Rules:

- `id` = change base name,
- `title` = human-readable title,
- `based_on` = real official functional truth files used as base,
- `affects` = real official functional truth files likely impacted,
- if no official functional truth exists yet, use `based_on: []` and `affects: []`,
- do not mark a newly written spec as `implemented`; final implemented reality belongs to the implementation/finalization workflow.

### Step 7: Write the macro sections

Always write these sections in this order:

1. `Problem`
2. `Objective`
3. `Out of Scope`
4. `Functional Blocks`

Conditional sections:

- `Pending to Reach Ready` only for `draft`
- `Global Constraints and Conditions` only if they affect the whole spec
- `Implemented Result` is not written by this workflow

Rules:

- `Problem` and `Objective` always exist,
- `Out of Scope` always exists as a guard against overreach,
- if `Problem` or `Objective` is not materially applicable, use `Implicit` or `N/A`,
- keep these sections functional and concise,
- do not invent filler just to satisfy a section,
- keep detailed functional behavior in `Functional Blocks`, not in the macro sections.

### Step 8: Model the change as functional blocks

Break the change into functional blocks.

Each block must have:

- an ID like `FB-1`, `FB-2`,
- a block title,
- `Change Type: add | modify | remove`,
- `Requirements`,
- `Acceptance Criteria`.

Use these conditional subsections only when useful:

- `Functional References`
- `Context Needed`
- `Block Constraints and Conditions`
- `Key Scenarios`

Rules for conditional subsections:

- `Functional References`: point to specific official functional truth files when doing so materially helps the reader understand the block.
- `Context Needed`: include only the minimum existing functional context required to understand the block.
- `Block Constraints and Conditions`: use for block-local constraints only.
- `Key Scenarios`: include only when scenarios materially clarify expected behavior.

### Step 9: Write requirements correctly

For each block:

- number requirements as `FR-1.1`, `FR-1.2`, etc.,
- make every requirement functional,
- make every requirement verifiable,
- avoid implementation detail,
- express desired behavior, rules, or observable outcomes.

### Step 10: Write acceptance criteria correctly

Acceptance criteria are block-level, not requirement-level.

Rules:

- do not assign IDs to acceptance criteria,
- make them observable and testable in principle,
- use them to close functional ambiguity,
- do not restate requirements word-for-word if you can express clearer acceptance conditions.

### Step 11: Use scenarios only when they add clarity

`Key Scenarios` are optional.

Use them when they help show expected behavior more clearly.

Rules:

- no IDs,
- keep them concrete,
- use them to clarify, not to replace requirements,
- do not add a scenario if the requirement is already fully clear without it,
- prefer scenarios for combinations, edge cases, or interpretations that are harder to understand from requirements alone,
- remove scenarios that only restate a requirement without adding a meaningful example or disambiguation.

### Step 12: Deduplicate within functional blocks

Before finalizing the spec, review each functional block for semantic redundancy.

Focus this deduplication on requirements and scenarios.

Rules:

- merge overlapping requirements when they express the same behavioral rule,
- keep separate requirements only when they define meaningfully different functional obligations,
- remove scenarios that merely paraphrase an already clear requirement,
- keep scenarios that clarify combined conditions, edge cases, or likely misreadings,
- do not remove acceptance criteria only because they overlap conceptually with requirements; acceptance criteria close what must be satisfied, which is a different role.

### Step 13: Validate readiness

Before writing the final file, verify:

- the spec is functional rather than technical,
- the macro structure matches the template,
- unresolved functional ambiguity is not hidden,
- `Out of Scope` is explicit,
- each functional block is well-formed,
- overlapping requirements inside a block have been merged when appropriate,
- scenarios that only restate clear requirements have been removed,
- every block has acceptance criteria,
- `based_on` and `affects` are grounded in real official functional truth files, or are `[]` when no official functional truth exists yet.

If there are still open functional decisions, keep the status at `draft`.

If a constraint affects the whole spec rather than one block, place it in `Global Constraints and Conditions` instead. Typical examples include functional rollout limitations, compatibility constraints visible to users or operators, cross-block business rules, and audit or permission constraints that shape the whole change.

### Step 14: Write or update the file

Create or update the target spec file under `.redline/project/specs/<change>/<change>.spec.md`.

If the user asked only for the content first, you may present the draft before writing. Otherwise write the file directly when appropriate.

## Special Case: Updating an Existing Spec

If the user wants to refine an existing spec:

1. read the existing spec,
2. preserve its valid structure and IDs where possible,
3. improve clarity without silently changing intent,
4. fix status and pending items according to current understanding,
5. keep the file aligned with the official template.

## Post-Implementation Closure

Do not close specs after implementation in this workflow.

When implementation is finished, the implementation/finalization workflow is responsible for:

1. setting `status: implemented`,
2. adding `Implemented Result`,
3. summarizing actual implementation,
4. listing meaningful differences from the proposed change,
5. listing impacted functional truth files in `Impact on Functional Truth`,
6. updating frontmatter `affects` to final reality.

## Output Expectations

A good result from this workflow is:

- exactly one valid `*.spec.md` contract,
- minimal but sufficient,
- fully in English,
- easy for a human to read,
- easy for another agent to consume,
- and aligned with the RedlineSpec contract philosophy.

## Final Checklist

Before finishing, confirm all of these:

- The change really belongs in RedlineSpec flow.
- The change path under `.redline/project/specs/<change>/` is meaningful and non-sequential.
- `id` matches the change base name.
- The spec is in English.
- The spec is functional, not technical.
- Main sections are present and ordered correctly.
- Macro sections do not restate detailed behavior that belongs in `Functional Blocks`.
- Conditional sections appear only when appropriate.
- Block IDs use `FB-*`.
- Requirement IDs use `FR-*`.
- No IDs are used for scenarios or acceptance criteria.
- `based_on` and `affects` reference real official functional truth files, or are `[]` when no official functional truth exists yet.
- If `draft`, pending functional decisions are explicit.
- If `ready`, no unresolved functional ambiguity remains.
- `implemented` closure is left to the implementation/finalization workflow.

## What Not To Do

Do not:

- turn the spec into a technical implementation plan,
- include architecture, module design, APIs, signatures, or code-level solution detail,
- duplicate large parts of existing functional truth without need,
- leave functional intent implicit when it should be explicit,
- mark a spec as `ready` while open functional decisions remain,
- keep `Pending to Reach Ready` once the spec is no longer `draft`,
- add explicit merge instructions in `Impact on Functional Truth`.

## Default Behavior When Uncertain

If unsure whether something belongs in the spec:

- prefer functional clarity over extra detail,
- prefer explicit scope over implied scope,
- prefer omitting technical design,
- prefer asking one more focused question rather than guessing.
