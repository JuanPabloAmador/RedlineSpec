---
name: bootstrap-functional-truth
description: Execute the RedlineSpec /bootstrap-functional-truth workflow. Use after RedlineSpec is installed in a project to create or refine the initial living functional truth from repository evidence and user context.
---

# RedlineSpec /bootstrap-functional-truth Workflow

Use this skill to create or refine the initial living functional truth for a project.

This is a workflow skill. It is not the installer.

It works only after the RedlineSpec project structure already exists under `.redline/`.

## Read First

Before doing anything else, read these templates:

- `.redline/system/templates/functional.index.template.md`
- `.redline/system/templates/functional.entry.template.md`
- `.redline/system/templates/functional.global.entry.template.md`

Then read the current functional truth files that exist under:

- `.redline/project/functional-truth/functional.index.md`
- `.redline/project/functional-truth/*.entry.md`
- `.redline/project/functional-truth/*.global.entry.md`

Template resolution is installation-relative: locate the target project root that contains `.redline/system/templates/`, then read templates from that directory. If the required templates or `.redline/project/functional-truth/functional.index.md` are missing, stop and report that RedlineSpec installation is incomplete or must be refreshed.

## Purpose of /bootstrap-functional-truth

`/bootstrap-functional-truth` exists to turn an installed but incomplete functional truth into a useful baseline.

Its expected result is one of these:

- a minimally valid `functional.index.md` that clearly says no functionality is documented yet,
- a high-level functional index that maps large or uncertain areas and marks discovery gaps,
- or a functional index plus detailed `*.entry.md` and `*.global.entry.md` files for bounded areas whose current behavior is clear.

The output is persistent project truth, not a temporary change contract.

## Core Model

The living functional truth is analogous to `main` in Git.

Bootstrap is not a merge from a spec. Bootstrap creates the first useful `main` from current repository reality and user-confirmed context.

The workflow has three modes:

- `empty`: no functional behavior can be inferred; keep or create only a minimal index state.
- `large-or-uncertain`: broad functional areas can be identified, but details are not reliable enough; update the index and mark areas as documentation gaps.
- `bounded`: the repository has a small or clear enough functional surface to document current truth directly in entry files.

## Embedded Contract Rules

Always apply these rules:

1. Describe only current functional truth, not planned behavior.
2. Do not invent behavior to make the documentation look complete.
3. Do not create detailed entries for areas whose behavior is not clear from evidence or confirmed user context.
4. Prefer high-level index gaps over low-confidence truth.
5. Keep `functional.index.md` small; it routes and summarizes, it does not absorb the whole product.
6. Use `*.entry.md` for bounded functional areas.
7. Use `*.global.entry.md` for cross-cutting functional truth such as permissions, plans, states, lifecycle rules, or constraints that apply across multiple areas.
8. Keep all generated functional truth documents in English.
9. Use real repository paths only when referencing source evidence in notes or final reports; functional truth navigation should link functional truth files.
10. Do not create temporary specs, plans, or tasks from this workflow.
11. Do not modify application code.
12. Do not overwrite existing functional truth unless the new content is better aligned with current repository reality and preserves valid existing truth.

## Status and Coverage

Use these frontmatter values for functional truth documents:

- `status: active` when the document represents current known truth.
- `status: needs-discovery` when the area is recognized but not documented enough to rely on.
- `coverage: high-level` when the document only gives a routing or summary view.
- `coverage: partial` when some current behavior is documented but known gaps remain.
- `coverage: complete` only when the current known scope is fully documented from evidence or user confirmation.

Do not use `complete` for large or uncertain areas.

## When To Use This Skill

Use this skill when:

- the user says `/bootstrap-functional-truth`,
- RedlineSpec has been installed and the project needs its first useful functional truth,
- a repo has no specs yet but future specs need a baseline,
- an existing `functional.index.md` still contains template placeholders,
- or the project needs a high-level map of functional areas and discovery gaps before deeper documentation.

## Preconditions

The repository must already contain:

- `.redline/system/templates/functional.index.template.md`
- `.redline/system/templates/functional.entry.template.md`
- `.redline/system/templates/functional.global.entry.template.md`
- `.redline/project/functional-truth/functional.index.md`

If these are missing, stop. Tell the user to install or refresh RedlineSpec instead of silently acting as the installer.

## Non-Goals

Do not use this workflow to:

- merge an implemented spec into functional truth,
- close or update a spec after implementation,
- document planned functionality,
- create tasks or implementation plans,
- write project technical rules,
- or implement application code.

## Workflow

Follow this sequence.

### Step 1: Validate installation

Confirm the required `.redline/` structure and templates exist.

Block if:

- `.redline/system/templates/functional.index.template.md` is missing,
- `.redline/system/templates/functional.entry.template.md` is missing,
- `.redline/system/templates/functional.global.entry.template.md` is missing,
- `.redline/project/functional-truth/functional.index.md` is missing,
- or `.redline/project/functional-truth/` is missing.

### Step 2: Load current functional truth

Read:

- `functional.index.md`,
- all existing `*.entry.md`,
- all existing `*.global.entry.md`.

Identify whether the current files are:

- untouched placeholders,
- partially useful truth,
- stale or contradictory,
- or already a usable baseline.

Preserve valid current truth.

### Step 3: Inspect repository evidence

Inspect the repository to identify functional behavior from evidence such as:

- README or product documentation,
- route definitions,
- UI screens and components,
- API endpoints,
- controllers, services, commands, jobs, or workflows,
- domain models and state machines,
- tests that describe behavior,
- configuration that exposes user-visible modes or permissions.

Do not infer detailed behavior from filenames alone.

### Step 4: Classify bootstrap mode

Choose exactly one mode.

Use `empty` when:

- there is no product code,
- no user-facing or system-facing behavior can be inferred,
- and the user has not provided functional context.

Use `large-or-uncertain` when:

- broad areas are visible,
- but the details are too large, incomplete, or ambiguous to document reliably in one pass.

Use `bounded` when:

- the product surface is small or focused,
- current behavior can be identified from evidence or user context,
- and detailed functional truth can be written without guessing.

If the mode is unclear, ask one focused question before writing.

### Step 5: Decide the functional truth shape

For `empty` mode:

- keep `functional.index.md` minimal,
- set `status: needs-discovery`,
- set `coverage: high-level` or an equivalent explicit low-coverage value if the existing project already uses one,
- list the main gap as initial functional discovery,
- do not create `*.entry.md` files.

For `large-or-uncertain` mode:

- update `functional.index.md` with high-level functional areas,
- mark areas whose details are not documented as gaps,
- create no detailed entry for low-confidence areas,
- create `*.entry.md` only for areas with high-confidence current truth.

For `bounded` mode:

- update `functional.index.md`,
- create or update `*.entry.md` files for each coherent functional area,
- create or update `*.global.entry.md` files only for real cross-cutting truth,
- keep each entry small or medium-sized.

### Step 6: Name files

Use lowercase kebab-case names.

For area entries:

- `.redline/project/functional-truth/<area>.entry.md`

For global entries:

- `.redline/project/functional-truth/<topic>.global.entry.md`

Examples:

- `admin.entry.md`
- `checkout.entry.md`
- `blog.entry.md`
- `permissions.global.entry.md`
- `subscription-limits.global.entry.md`

Avoid sequential names.

### Step 7: Write functional truth

Use the official templates as shapes.

Rules:

- keep the index as routing and overview,
- keep details inside entries,
- use documentation gaps openly where discovery remains,
- do not encode implementation details unless they are necessary to understand functional behavior,
- do not include roadmap or future work as current truth.

### Step 8: Validate before finishing

Before finishing, verify:

- no template placeholders remain in files you wrote,
- every index link points to a real functional truth file or is clearly listed as a gap instead of a link,
- every created entry represents current behavior with sufficient evidence,
- every uncertain area is marked as a documentation gap,
- no temporary spec, plan, or task was created,
- no application code was modified.

### Step 9: Recommend the next startup workflow

Before the final response, check whether the project has any real `*.rule.md` files under `.redline/project/rules/`.

If no project rules exist yet, recommend `/write-rules` as the next workflow for capturing reusable technical practices before the first planned implementation flow.

This recommendation is non-blocking. Do not create or modify rules from this workflow.

## Blocked Report Format

When blocking, report:

- blocking reason,
- evidence observed,
- affected functional truth files,
- missing information,
- recommended next workflow or user decision.

## Output Expectations

A good result from this workflow is:

- a usable initial functional truth baseline,
- explicit coverage and gaps,
- no invented functionality,
- small navigable files,
- a clear final report of what was documented and what remains to discover,
- and, when no project rules exist yet, a recommendation to run `/write-rules` next.

## Final Checklist

Before finishing, confirm all of these:

- RedlineSpec installation was present.
- Required templates were loaded.
- Current functional truth was read before writing.
- Repository evidence was inspected.
- Bootstrap mode was chosen explicitly.
- Low-confidence areas were not documented as truth.
- `functional.index.md` remains small.
- Created entries use the official templates.
- All generated functional truth is in English.
- No code, spec, plan, task, or rules files were modified by this workflow.
- If no project rules exist yet, `/write-rules` was recommended as the next startup workflow.
