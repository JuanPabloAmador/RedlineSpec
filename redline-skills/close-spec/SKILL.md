---
name: close-spec
description: Execute the RedlineSpec /close-spec workflow. Use after implementation to verify the real code behavior against a Spec, align the Spec with what was actually implemented, and mark it implemented when evidence is sufficient.
---

# RedlineSpec /close-spec Workflow

Use this skill to close a RedlineSpec `Spec` after implementation.

This is a workflow skill. It verifies and updates a contract; it does not implement code.

## Read First

Before doing anything else, read:

- the target `.redline/project/specs/<change>/<change>.spec.md`
- `.redline/system/templates/spec.template.md`

When available, also read:

- `.redline/project/specs/<change>/plan/<change>.plan.md`
- `.redline/project/specs/<change>/tasks/<change>.tasks.md`
- `.redline/project/specs/<change>/tasks/*.task.md`
- current relevant functional truth files under `.redline/project/functional-truth/`
- repository code, tests, and documentation needed to verify the implemented behavior

Template resolution is installation-relative: locate the target project root that contains `.redline/system/templates/`, then read templates from that directory. If `.redline/system/templates/spec.template.md` is missing, stop and report that the RedlineSpec system installation is incomplete or must be refreshed.

## Purpose of /close-spec

`/close-spec` exists to align the functional branch with implemented reality before it is merged into the living functional truth.

Its expected result is:

- one `*.spec.md` updated to `status: implemented`,
- an `Implemented Result` section that accurately summarizes what was actually implemented,
- relevant differences from the proposed change made explicit,
- final impacted functional truth files listed,
- and enough verification evidence to trust the spec as the source for `/merge-functional-truth`.

## Core Model

A `Spec` starts as the functional branch of a change.

After implementation, that branch must be checked against real code and updated so it no longer describes intent alone. Only then can it be merged into functional truth.

`/close-spec` prepares the branch for merge. `/merge-functional-truth` performs the merge.

## Embedded Contract Rules

Always apply these rules:

1. Do not modify application code.
2. Do not update functional truth.
3. Do not delete temporary change documents.
4. Verify actual implemented behavior from repository evidence.
5. Use tasks, plans, and tests as evidence, but do not trust status fields alone.
6. Mark the spec `implemented` only when evidence is sufficient.
7. If behavior cannot be verified, block instead of guessing.
8. If implementation materially differs from the proposed functional outcome, ask the human before accepting that difference into the spec.
9. If implementation is incomplete, block and report what remains.
10. Keep the spec functional, not technical.
11. Preserve valid functional block IDs and requirement IDs where possible.
12. Keep the spec in English.
13. Update frontmatter `affects` to the final impacted functional truth files when they can be identified.
14. If no official functional truth exists yet, use `affects: []` and state that merge requires functional truth bootstrap first.

## When To Use This Skill

Use this skill when:

- the user says `/close-spec`,
- implementation has finished and the final `Spec` must be updated,
- `/implement` completed tasks and the spec needs post-implementation closure,
- a simple flow was implemented without tasks and now the spec must be aligned,
- or `/merge-functional-truth` blocks because the spec is not closed.

## Preconditions

The target spec must exist at:

- `.redline/project/specs/<change>/<change>.spec.md`

The spec should be `ready` before implementation, but this workflow may read a `draft` spec if the user explicitly asks to reconcile the current implementation. Do not mark a draft spec `implemented` while unresolved functional ambiguity remains.

## Non-Goals

Do not use this workflow to:

- implement missing code,
- fix failing tests,
- write or rewrite the Plan,
- write or rewrite Tasks,
- merge into functional truth,
- bootstrap functional truth,
- create project rules,
- or remove the temporary spec folder.

## Verification Standard

Use sufficient evidence.

Sufficient evidence can include:

- direct code inspection,
- tests or validation commands when available,
- completed task contracts and phase verification,
- public behavior exposed by routes, commands, UI, APIs, or domain workflows,
- documentation generated or updated by implementation when it is part of product behavior.

Executable tests are not mandatory when the repository has no relevant test surface, but if relevant tests exist and can be run, run them unless the user explicitly says not to.

Block when:

- a functional block cannot be verified,
- tasks exist and relevant tasks are not `done`,
- phase or task verification is blocked,
- tests fail in a way that affects the spec,
- the code implements a materially different functional outcome and the human has not accepted it,
- or the impacted functional truth files cannot be identified well enough for merge.

## Workflow

Follow this sequence.

### Step 1: Locate the target spec

If the user did not name a spec, inspect `.redline/project/specs/` and identify candidate specs.

If exactly one plausible candidate exists, use it. If more than one exists, ask which spec to close.

### Step 2: Load contract shape and upstream documents

Read:

- `.redline/system/templates/spec.template.md`
- the target spec

If present, read:

- source plan,
- task index,
- task files,
- relevant current functional truth files.

### Step 3: Inspect implementation evidence

Inspect repository areas likely affected by the spec.

Use:

- the spec's functional blocks,
- the plan's affected areas,
- task file scopes and acceptance contracts,
- changed files when available,
- relevant tests and docs.

Do not assume a task marked `done` proves behavior by itself.

### Step 4: Run relevant verification

Run focused validation commands when they are available and relevant.

Prefer existing project scripts or test commands.

Do not invent heavyweight verification when the repo does not provide a clear path.

If verification cannot be run, continue only if code and contract evidence are otherwise sufficient. Mention the limitation in the final report.

### Step 5: Compare spec to implemented reality

For each functional block:

- determine whether the intended behavior is implemented,
- identify any behavior that differs from the proposed spec,
- identify any proposed behavior that is missing,
- identify any implemented behavior that should be reflected in the spec.

Classify differences as:

- `non-functional`: implementation detail only; do not put it in the spec,
- `accepted-functional`: behavior differs but is acceptable as final product truth,
- `blocking-functional`: behavior differs and cannot be accepted without user decision or more implementation.

Ask the human before treating a material functional difference as accepted.

### Step 6: Update the spec

Only update the spec if closure is valid.

Required changes:

- set frontmatter `status: implemented`,
- update `affects` to final impacted functional truth files,
- remove `Pending to Reach Ready`,
- keep or refine `Functional Blocks` so they describe the implemented functional truth of the change,
- add `Implemented Result`,
- add `Implementation Summary`,
- add `Relevant Differences from Proposed Change`,
- add `Impact on Functional Truth`.

Use `- None.` under `Relevant Differences from Proposed Change` only when there are no meaningful functional differences.

`Impact on Functional Truth` must list the files that `/merge-functional-truth` should create or update. Use real paths such as:

- `.redline/project/functional-truth/functional.index.md`
- `.redline/project/functional-truth/<area>.entry.md`
- `.redline/project/functional-truth/<topic>.global.entry.md`

If a new functional truth file is needed, include its intended path.

### Step 7: Validate the closed spec

Before finishing, verify:

- status is `implemented`,
- `Implemented Result` exists,
- `Implementation Summary` exists,
- `Relevant Differences from Proposed Change` exists,
- `Impact on Functional Truth` exists,
- `Pending to Reach Ready` is absent,
- no unresolved functional ambiguity remains,
- final `affects` and `Impact on Functional Truth` align,
- the spec remains functional, not technical.

## Blocked Report Format

When blocking, report:

- blocking reason,
- evidence observed,
- affected spec section or functional block,
- relevant files or commands,
- whether the next step is `/implement`, `/write-spec`, or a user decision,
- and what must become true before `/close-spec` can succeed.

## Output Expectations

A good result from this workflow is:

- no application code changed,
- no functional truth changed,
- one spec accurately representing implemented reality,
- enough evidence to trust the spec for merge,
- and a clear final report of verification performed and any limitations.

## Final Checklist

Before finishing, confirm all of these:

- The target spec was read.
- The official spec template was read.
- Plan and tasks were read when present.
- Relevant implementation evidence was inspected.
- Relevant validation was run or its absence was explained.
- No application code was modified.
- No functional truth was modified.
- Material functional differences were accepted by the human or blocked.
- The spec has `status: implemented` only if evidence was sufficient.
- `Impact on Functional Truth` is ready for `/merge-functional-truth`.
