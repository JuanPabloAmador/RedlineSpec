---
name: write-tasks
description: >-
  RedlineSpec workflow skill for write-tasks. Also use for create tasks, task contracts, task decomposition, vertical phases, and plan-to-tasks. Use this workflow skill to decompose a ready technical Plan into an ordered task index and compact individual task contracts under .redline/project/specs/<change>/tasks/. Do not use to implement tasks, repair incomplete Plans, update functional truth, write Specs or Plans, create rules, or taskify final functional truth consolidation.
---

# RedlineSpec write-tasks Workflow

Use this skill to execute the operational workflow for writing RedlineSpec `Tasks`.

This is a workflow skill.

It turns a ready technical `Plan` into an ordered task index and individual task contract files.

## Read First

Before doing anything else, read these templates:

- `.redline/system/templates/tasks.template.md`
- `.redline/system/templates/task.template.md`

Then read:

- the source `*.plan.md` index
- the linked technical unit files needed for the current task generation pass
- the relevant portions of the source `*.spec.md`

When task files already exist, also inspect the task index and filesystem state under:

- `.redline/project/specs/<change>/tasks/`

Template resolution is installation-relative: locate the target project root that contains `.redline/system/templates/`, then read templates from that directory. If either required template is missing, stop and report that the RedlineSpec system installation is incomplete or must be refreshed.

## Purpose of write-tasks

`write-tasks` turns a ready Plan into executable contracts.

It does not implement code.

It does not update functional truth.

It does not repair an incomplete Plan.

The output is:

- one operational task index,
- and one individual task contract file per task.

## Core Model

Tasks are organized by vertical phases.

A phase is the vertical unit. It must represent a functionally verifiable slice of the change.

A task is a small contractual step inside a phase. A task does not have to be vertical by itself.

Avoid horizontal task planning such as doing all types, all UI, all server work, or all tests as separate global phases.

Tasks are produced in two passes:

1. **Pass 1:** write the initial task index applying the user's instructions on how tasks should be shaped.
2. **Pass 2:** force a task-by-task review applying the Granularity Decomposition criteria below, splitting any task that bundles more than one unit of work.

Write each phase with an `Execution Tree` in the index. The tree is where you express all order and dependency between tasks. Task files must not reference other tasks, must not declare dependencies, and must not mention the tree.

## Execution Tree Semantics

Use these rules when writing the `Execution Tree`:

- Write the tree as a directed acyclic graph: each task appears exactly once.
- Place a task only under its parent: the task runs after its parent completes.
- Mark sibling groups (children of the same parent) with `[∥]`: they are parallelizable and wait only for their parent.
- Mark a `[∥]` group only when the sibling tasks do not touch the same files. If siblings share files, restructure the tree instead of keeping the parallel group.
- Keep parent-child chains serial: a child always waits for its parent.
- A task may unlock any number of child tasks, and each child may unlock further children.

## Granularity Decomposition

This is the Pass 2 review. Review every task in the index one by one. A task must represent exactly one unit of work.

Split a task when any of these signals is present:

- the task touches more than one domain,
- the flow it implements can be decomposed into steps that each make sense as a standalone task with its own verification,
- the task's `Change Scope` covers more than one artifact or more than one functional unit,
- the files it writes do not form a single functional unit,
- or the task needs more context than its own compact contract.

As a minimum reference, one artifact gets at least one task: in a frontend, each component gets at least its own task; in a backend, each service, controller, or endpoint gets at least its own task. Depending on complexity, a single artifact may require several tasks. A task that bundles two components, or a component plus unrelated configuration, must be split.

After splitting, each resulting task must pass the same review, and the phase `Execution Tree` must be updated to keep the split consistent.

## Embedded Contract Rules

Always apply these rules:

1. Use the exact section names and overall shapes from `.redline/system/templates/tasks.template.md` and `.redline/system/templates/task.template.md`.
2. Keep all generated task documents in English.
3. Generate the index before generating task files.
4. Do not generate task files until the index is explicitly approved by the user.
5. Use vertical phases: every phase must have a functional slice and functional verification.
6. If a vertical phase cannot be made functionally verifiable, block and require clarification or Plan revision.
7. Do not add a separate priority field.
8. Execution between phases is sequential by default: a phase starts only when the previous phase is verified.
9. Write an `Execution Tree` in every phase using the rules above.
10. Express all order and dependencies only through the `Execution Tree`.
11. Do not reference other tasks, declare dependencies, or mention the tree in task files.
12. Mark parallelizable sibling groups with `[∥]` in the tree. A `[∥]` group must not contain tasks that share files.
13. Use TDD-oriented ordering when applicable: test tasks may come after implementation tasks in the same branch of the tree.
14. Individual task files are compact contracts, not implementation recipes.
15. Do not include implementation steps or execution notes in task files.
16. Every task file must include `Acceptance Contract`; it combines what must be true and how it is validated.
17. Every task file must include `Contract Shapes`; use `N/A` with a brief justification when no shape or signature applies.
18. Every task file must include `Relevant Rules`; use `None.` when no rule applies.
19. The index references rules; task files expand only the relevant rule content needed for that task.
20. Do not taskify final functional truth consolidation.
21. Never overwrite a task file with `status: done`.
22. If task decomposition reveals a new functional decision, functional gap, or discovered behavior that affects the source Spec, add or update a temporary `## Consolidation Notes` section in the source Spec with a concise `CN-*` entry.
23. Use Consolidation Notes only for functional discoveries. Do not use them for task sequencing, implementation details, technical shortcuts, or execution notes.
24. When adding a Consolidation Note, use this format: `- **CN-N:** Concise functional decision or discovery.`, followed by `Origin:` and `Impact:` sub-bullets. If the section does not exist, insert it between `## Global Constraints and Conditions` and `## Functional Blocks`. If it already exists, append the next `CN-*` entry.

## When To Use This Skill

Use this skill when:

- the user says `write-tasks`,
- a ready `Plan` must be decomposed into implementation tasks,
- a task index must be created or revised,
- individual task files must be generated from an approved index,
- or an existing task generation pass must be continued.

## Preconditions

The source Plan must be ready.

It must contain enough information to derive:

- technical blocks,
- linked technical unit contracts,
- signatures and shapes,
- affected existing areas,
- new artifacts,
- and applicable rules.

If the Plan is not ready or lacks essential implementation constraints, do not patch the Plan from this workflow. Block and list what is missing.

If the Plan intentionally has no project rules, task generation may continue, but report that the resulting task contracts will use `None.` for `Relevant Rules` where appropriate and will not benefit from reusable project-level technical constraints. Recommend `write-rules` followed by `write-plan` revision if the user wants project rules reflected in task contracts before implementation.

## Non-Goals

Do not use this workflow to:

- write the Spec,
- write the Plan,
- implement code,
- execute task files,
- close the Spec after implementation,
- update functional truth,
- or define the `implement` workflow.

## Canonical Paths

Given a change base name `<change>`, write:

- `.redline/project/specs/<change>/tasks/<change>.tasks.md`
- `.redline/project/specs/<change>/tasks/phase-01-task-01-<slug>.task.md`

Task files live flat under `tasks/`.

File names must preserve order:

- `phase-01-task-01-<slug>.task.md`
- `phase-01-task-02-<slug>.task.md`
- `phase-02-task-01-<slug>.task.md`

The index order and file numbering must match strictly.

## Workflow

Follow this sequence.

### Step 1: Load templates

Read:

- `.redline/system/templates/tasks.template.md`
- `.redline/system/templates/task.template.md`

Treat those templates and the rules embedded in this skill as canonical.

### Step 2: Locate the source Plan and Spec

Expected Plan path:

- `.redline/project/specs/<change>/plan/<change>.plan.md`

Expected Spec path:

- `.redline/project/specs/<change>/<change>.spec.md`

The Plan is the primary technical source.

Read linked technical unit files from:

- `.redline/project/specs/<change>/plan/technical-units/`

Use progressive disclosure for technical unit files: read only the units needed to create or validate the current phases or task files.

Use progressive disclosure for the Spec: read only the functional blocks, requirements, and acceptance material needed for the phases or task files currently being generated.

### Step 3: Validate Plan readiness

The Plan must be ready to taskify.

Block if:

- the Plan status is not ready,
- open technical questions remain,
- linked technical unit files are missing,
- linked technical unit files are not ready,
- technical unit contracts are vague,
- signatures or shapes are missing where needed in unit files,
- affected areas are not concrete enough,
- new artifacts are unclear,
- or rules referenced by the Plan cannot be resolved when they are needed for task contracts.

If the ready Plan references no project rules, do not block only for that reason. Continue only after making the limitation explicit: generated task files may use `None.` in `Relevant Rules`, and implementation will rely on the Plan, task contracts, and repository context rather than expanded project rules.

Report missing information directly and stop.

### Step 4: Decide mode from current state

If no task index exists, create the index first.

If a task index exists:

1. read the full index,
2. validate it against the Plan and relevant Spec context,
3. compare expected task files in the index against the filesystem,
4. block on extra `.task.md` files not declared in the index,
5. if `index_approved: false`, ask for approval before generating task files.

Do not use metadata to track which task files exist. The index declares expected files; the filesystem confirms actual files.

### Step 5: Create or revise the task index

Use:

- `.redline/project/specs/<change>/tasks/<change>.tasks.md`

The index frontmatter must contain:

- `id`
- `title`
- `status`
- `index_approved`
- `spec`
- `plan`

Set `index_approved: false` when creating or materially revising the index.

Set `status: blocked` if questions remain.

Set `status: pending` only when the index is closed enough to approve and later generate task files.

### Step 6: Build vertical phases

Each phase must define:

- functional slice,
- scope,
- optional out of scope,
- functional verification,
- execution tree,
- tasks.

The functional verification can be manual, technical, or both depending on the Spec.

If the Plan does not naturally support functionally verifiable phases, ask focused follow-up questions. If the issue is structural, block and request Plan revision.

### Step 7: Pass 1 — Define tasks inside each phase

Each task in the index must include:

- task ID such as `P01-T01`,
- type,
- status,
- file name,
- short contract summary.

Allowed task types:

- `test`
- `implementation`
- `migration`
- `refactor`
- `verification`
- `documentation`
- `other`

Write the initial tasks following the user's instructions on how tasks should be shaped. Tasks should be small enough for a short session and have one clear result. If the user has not given shaping instructions, use the Granularity Decomposition criteria directly while writing.

### Step 8: Pass 2 — Review granularity and build the Execution Tree

Force a task-by-task review applying the Granularity Decomposition criteria. Split every task that bundles more than one unit of work.

Then build the phase `Execution Tree`:

1. write the tree in filesystem style with the root task first and children indented,
2. mark parallelizable sibling groups with `[∥]`,
3. validate the tree is a DAG and every task appears exactly once,
4. validate that no `[∥]` sibling group contains tasks that share files; if they do, restructure the tree so the shared work becomes an ancestor,
5. validate that the tree matches the task table: same task IDs, no missing or extra tasks.

### Step 9: Validate task traceability

The task index is an execution map for vertical phases, per-phase execution trees, task order, status, and parallelization metadata.

Task-level traceability belongs in each individual `*.task.md` file under `Source Trace`.

Before asking for index approval, validate that:

- every task has a clear source in the ready Plan,
- every phase is supported by Plan blocks or linked technical unit contracts,
- the ready Plan has already covered the source Spec,
- and no Plan block or technical unit needed for execution has been dropped from the phase/task decomposition.

If the ready Plan appears not to cover the Spec, block and recommend `write-plan` revision.

If task decomposition drops required Plan material, block and revise the task index.

### Step 10: Explain and request approval

After writing the index, explain briefly to the user:

- how the vertical cuts are organized,
- what each phase delivers,
- where parallel execution exists (`[∥]` sibling groups and the waves they unlock),
- and why the tree is structured that way.

Then ask for explicit approval before generating task files.

Only after explicit approval may you set:

- `index_approved: true`

### Step 11: Generate task files incrementally

When generating task files:

1. read the full index,
2. list existing task files under `tasks/`,
3. compare expected files from the index against filesystem files,
4. block on extra `.task.md` files not declared in the index,
5. find the latest materialized task by filename order,
6. open only that latest task to check `contract_ready`,
7. complete that task if `contract_ready: false`,
8. otherwise continue with the next expected task.

If there are several phases or roughly more than 8-10 tasks, suggest generating task files by phase or session to control context size.

### Step 12: Write each task contract

Each task file frontmatter must contain:

- `id`
- `title`
- `status`
- `contract_ready`
- `phase`
- `type`
- `spec`
- `plan`

While writing or recovering a partial task file, use:

- `contract_ready: false`

When the task contract is complete, set:

- `contract_ready: true`

Keep `status: pending` until implementation begins.

### Step 13: Fill task sections correctly

Every task file must include:

- `Source Trace`
- `Task Contract`
- `Change Scope`
- `Acceptance Contract`
- `Contract Shapes`
- `Relevant Rules`
- optional `Repository Context`
- `Blocked Protocol`

`Source Trace` contains the source Spec, Plan index, relevant technical unit file paths, functional references, technical references, and rule paths.

`Change Scope` must declare existing artifacts allowed to change and new artifacts allowed to create. New artifacts may be exact paths or allowed path patterns.

`Acceptance Contract` combines requirements and verification. A task can only become `done` if this contract is satisfied.

`Contract Shapes` contains signatures, public surfaces, inputs, outputs, or data contracts. Use `N/A` only with a brief justification.

`Relevant Rules` expands the rules needed for this task, not every rule from the Plan.

`Repository Context` appears only when needed.

`Blocked Protocol` must state when to stop and what to report.

### Step 14: Handle regeneration

Task files that are not implemented may be overwritten when regenerating from an updated index or Plan.

Never overwrite a task file with:

- `status: done`

If an updated index or Plan affects a done task, add a new adjustment task instead.

Place the adjustment task in the same phase if it preserves the vertical cut. Create a new phase if it changes the vertical result.

## Output Expectations

A good result from this workflow is:

- a valid task index,
- vertical phases with functional verification,
- a per-phase `Execution Tree` with explicit parallelizable sibling groups,
- tasks that each cover exactly one unit of work,
- compact task-level source traceability in each individual task file,
- and individual task files that are compact, autonomous, ready execution contracts.

## Final Checklist

Before finishing, confirm all of these:

- Required templates were loaded from `.redline/system/templates/`.
- The Plan exists and is ready.
- Relevant Spec context was read with progressive disclosure.
- The task index path is `.redline/project/specs/<change>/tasks/<change>.tasks.md`.
- The index frontmatter includes `id`, `title`, `status`, `index_approved`, `spec`, and `plan`.
- Every phase has a functional slice and functional verification.
- Every task is listed with ID, type, status, file, and summary.
- Every task passed the Granularity Decomposition review: one unit of work per task.
- Every phase has an `Execution Tree` written in filesystem style.
- `[∥]` markers are present on every parallelizable sibling group.
- No `[∥]` sibling group contains tasks that share files.
- The tree is a DAG and every task appears exactly once.
- The tree matches the task table.
- No task file references other tasks, dependencies, or the tree.
- All order and dependencies are expressed only through the `Execution Tree`.
- The index provides phases, trees, order, status, and parallelization.
- Each individual task file provides task-level traceability through `Source Trace`.
- Task files use flat naming under `tasks/`.
- Every task file has required frontmatter.
- Every complete task file has `contract_ready: true`.
- No `status: done` task file was overwritten.

## What Not To Do

Do not:

- create horizontal implementation phases,
- generate task files before index approval,
- add priority fields,
- express order or dependencies outside the `Execution Tree`,
- let task files reference other tasks or the tree,
- write implementation steps or execution notes in task files,
- expand every rule into every task,
- repair the Plan from this workflow,
- implement code,
- or create functional truth consolidation tasks.

## Next Workflow

When this workflow finishes, tell the user the next step is to run `implement`.
