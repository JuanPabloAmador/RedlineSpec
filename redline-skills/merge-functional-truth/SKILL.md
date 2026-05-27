---
name: merge-functional-truth
description: Execute the RedlineSpec /merge-functional-truth workflow. Use after one or more Specs are closed as implemented to consolidate their functional result into the living functional truth and remove temporary change documents.
---

# RedlineSpec /merge-functional-truth Workflow

Use this skill to merge implemented specs into the living functional truth.

This is a workflow skill. It updates persistent functional truth from already closed specs.

It does not verify implementation code. That belongs to `/close-spec`.

## Read First

Before doing anything else, read:

- each target `.redline/project/specs/<change>/<change>.spec.md`
- `.redline/system/templates/functional.index.template.md`
- `.redline/system/templates/functional.entry.template.md`
- `.redline/system/templates/functional.global.entry.template.md`
- `.redline/project/functional-truth/functional.index.md`
- all affected `*.entry.md` and `*.global.entry.md` files listed by the specs

If a listed affected functional truth file does not exist yet, read the appropriate template for creating it.

Template resolution is installation-relative: locate the target project root that contains `.redline/system/templates/`, then read templates from that directory. If required templates or `.redline/project/functional-truth/functional.index.md` are missing, stop and report that RedlineSpec installation is incomplete or must be refreshed.

## Purpose of /merge-functional-truth

`/merge-functional-truth` exists to consolidate a completed functional branch back into the living functional truth.

Its expected result is:

- updated `functional.index.md` when needed,
- updated affected `*.entry.md` files,
- updated affected `*.global.entry.md` files,
- newly created functional truth files when the implemented spec adds a new functional area,
- and removal of the temporary spec folders that were successfully merged.

## Core Model

The living functional truth is analogous to `main` in Git.

A `Spec` is analogous to a branch.

Only a stable, implemented, closed spec can merge into main. If the spec is not closed or the merge target is ambiguous, do not merge.

This workflow can merge one spec or a closed set of multiple specs in a single execution.

## Embedded Contract Rules

Always apply these rules:

1. Merge only from specs with `status: implemented`.
2. Require `Implemented Result`, `Implementation Summary`, `Relevant Differences from Proposed Change`, and `Impact on Functional Truth` in every spec.
3. Do not inspect code to reinterpret the implementation; use `/close-spec` first if the spec is not trustworthy.
4. Do not modify application code.
5. Do not modify specs except for removing their temporary folders after a successful merge.
6. Do not merge planned or future behavior into functional truth.
7. Update functional truth to describe the current product state after the implemented change.
8. Preserve valid existing functional truth that is not affected by the spec.
9. If the spec and current functional truth conflict semantically, block and tell the user to run `/close-spec` or resolve the spec first.
10. If multiple specs conflict with each other, block and require a corrected closed spec set.
11. Keep `functional.index.md` small; route details to entries.
12. Use `*.entry.md` for bounded functional areas.
13. Use `*.global.entry.md` for cross-cutting functional truth.
14. Keep all functional truth documents in English.
15. Remove successfully merged temporary spec folders after functional truth is updated and validated.

## When To Use This Skill

Use this skill when:

- the user says `/merge-functional-truth`,
- one implemented spec must be consolidated into functional truth,
- several implemented specs must be closed together as one stable functional merge,
- a new functional area must be added to the living functional truth from an implemented spec,
- or a finished change's temporary documents must be removed after consolidation.

## Preconditions

Every target spec must:

- exist under `.redline/project/specs/<change>/`,
- have `status: implemented`,
- include `Implemented Result`,
- include `Implementation Summary`,
- include `Relevant Differences from Proposed Change`,
- include `Impact on Functional Truth`,
- identify final affected functional truth files in frontmatter `affects` or `Impact on Functional Truth`.

If any spec does not satisfy these conditions, stop. Tell the user to run `/close-spec` for that spec first.

## Non-Goals

Do not use this workflow to:

- verify implementation code,
- close or align specs,
- create the initial functional truth baseline from repository discovery,
- write a new spec,
- write a plan or tasks,
- write project implementation rules,
- or implement application code.

## Workflow

Follow this sequence.

### Step 1: Determine merge set

Identify the spec or specs to merge.

If the user names one spec, merge only that spec.

If the user requests a group merge, list all candidate specs and confirm the merge set unless the set is already explicit.

Do not auto-merge every implemented spec in the repository unless the user explicitly asks for that.

### Step 2: Validate each spec is mergeable

For each spec, verify:

- frontmatter `status: implemented`,
- `Implemented Result` exists,
- `Implementation Summary` exists,
- `Relevant Differences from Proposed Change` exists,
- `Impact on Functional Truth` exists,
- no unresolved functional ambiguity remains,
- `Pending to Reach Ready` is absent.

Block if any spec fails validation.

### Step 3: Load current functional truth

Read:

- `.redline/project/functional-truth/functional.index.md`,
- all existing files listed in `affects`,
- all existing files listed in `Impact on Functional Truth`,
- any existing functional truth files that are linked from the index and likely to be semantically affected.

If a target file does not exist, classify it as a new functional truth file to create.

### Step 4: Check semantic merge safety

Compare each spec's implemented result with current functional truth.

Block when:

- the spec appears stale against the current functional truth,
- two specs in the merge set describe incompatible final truth,
- the target entry file is unclear or likely wrong,
- the merge would remove or rewrite unrelated truth,
- or the spec requires interpreting code to know what should be true.

When blocked, do not write functional truth. Tell the user to run `/close-spec` or resolve the spec set first.

### Step 5: Plan the functional truth updates

For each spec, decide whether the implemented truth requires:

- updating `functional.index.md`,
- updating an existing `*.entry.md`,
- creating a new `*.entry.md`,
- updating an existing `*.global.entry.md`,
- creating a new `*.global.entry.md`,
- removing obsolete functional statements from affected files.

Do not create a separate merge report document.

### Step 6: Apply the merge

Update functional truth files only.

Rules:

- write the final current behavior, not the history of the spec,
- integrate behavior into the right existing capability when possible,
- add new capabilities when the implemented behavior is new within an existing area,
- create new entries only when a coherent new functional area exists,
- create global entries only for cross-cutting truth,
- update index links and gaps when files are added or coverage changes,
- remove obsolete statements that are no longer true after the change,
- avoid mentioning the spec as an ongoing source of truth.

### Step 7: Validate the merged truth

Before deleting temporary documents, verify:

- every updated file has no template placeholders,
- index links point to real files,
- every spec's `Impact on Functional Truth` is reflected,
- no planned behavior was merged,
- no unrelated functional truth was removed,
- new entries use the official entry/global entry shapes,
- `functional.index.md` remains small.

### Step 8: Remove merged temporary documents

After a successful validation, remove the temporary folder for each merged spec:

- `.redline/project/specs/<change>/`

Remove only folders belonging to specs successfully merged in this execution.

Do not remove unrelated specs, blocked specs, or specs outside the merge set.

### Step 9: Final consistency check

After removal, verify:

- merged spec folders no longer exist,
- functional truth files still exist and are linked correctly,
- `.redline/project/specs/` contains only unmerged or unrelated work.

## Multi-Spec Merge Rules

When merging several specs together:

- validate every spec before writing any functional truth,
- build one combined view of the final truth,
- block if specs overlap in a contradictory way,
- apply updates once from the combined truth, not as isolated overwrites,
- delete all successfully merged spec folders only after the combined validation passes.

## Blocked Report Format

When blocking, report:

- blocking reason,
- affected spec or specs,
- affected functional truth files,
- evidence observed in the spec and current truth,
- recommended recovery workflow, usually `/close-spec`,
- and what must become true before merge can proceed.

## Output Expectations

A good result from this workflow is:

- living functional truth updated to match implemented specs,
- no application code changed,
- no speculative future behavior added,
- successfully merged temporary spec folders removed,
- and a clear final report of files updated and specs merged.

## Final Checklist

Before finishing, confirm all of these:

- Every merged spec had `status: implemented`.
- Every merged spec had `Implemented Result`.
- Current functional truth was read before writing.
- No code was inspected to reinterpret an unclosed spec.
- No application code was modified.
- No unresolved semantic conflict was merged.
- Functional truth now reflects the implemented result.
- Index links are valid.
- New entry files use official templates.
- Successfully merged spec folders were removed.
- Blocked or unrelated spec folders were preserved.
