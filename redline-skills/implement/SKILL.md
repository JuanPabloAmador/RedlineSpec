---
name: implement
description: Execute the RedlineSpec /implement workflow. Use when approved Tasks must be implemented sequentially from compact task contracts under .redline/project/specs/<change>/tasks/.
---

# RedlineSpec /implement Workflow

Use this skill to execute approved RedlineSpec `Tasks`.

This is a workflow skill.

It consumes an approved task index and individual task contract files, changes the repository, verifies the applicable contracts, and updates only the execution statuses already present in the task documents.

## Read First

Before implementing, read:

- the task index at `.redline/project/specs/<change>/tasks/<change>.tasks.md`,
- the target `*.task.md` file or files selected by the requested mode,
- and the real repository files needed to implement and verify the selected task.

Do not read the full source `Plan`, `Spec`, or project rules by default.

Only read upstream documents when the task contract is insufficient, contradictory, disputed, or blocked. If a task references a Spec but lacks enough functional context to implement safely, read only the referenced Spec context needed to recover that functional intent. Continue only if there is no contradiction with the task contract.

Template resolution is installation-relative: locate the target project root that contains `.redline/system/templates/`, then treat the distributed task templates and this skill as canonical execution rules. If required RedlineSpec task documents are missing, stop and report the incomplete setup or task generation state.

## Purpose of /implement

`/implement` executes `Tasks`.

It exists to:

- select executable task contracts from an approved task index,
- implement the required repository changes,
- verify the task-level `Acceptance Contract`, `Change Scope`, `Contract Shapes`, and `Relevant Rules`,
- verify the phase-level `Functional Verification` when a phase is completed,
- and keep execution statuses synchronized between the task index and task files.

`/implement` does not write new task contracts.

It does not redesign the Plan.

It does not update functional truth.

It does not update the final implemented Spec.

## Core Model

Tasks are executed from the task index order.

The order is the priority. There is no `depends_on` field.

Execution is sequential by default. Consecutive tasks with the same `parallel_group` in the index are safe parallelization metadata for compatible harnesses. The standard `/implement` workflow should detect and mention those groups, but execute serially unless the surrounding harness explicitly provides safe parallel execution.

A task file is the primary execution contract. It is expected to be compact and autocontained through:

- `Source Trace`,
- `Task Contract`,
- `Change Scope`,
- `Acceptance Contract`,
- `Contract Shapes`,
- `Relevant Rules`,
- optional `Repository Context`,
- and `Blocked Protocol`.

Do not add implementation evidence sections, execution logs, result sections, or other new sections to task files. `status: done` means the task's acceptance contract passed.

## Embedded Contract Rules

Always apply these rules:

1. Execute only from an approved task index with `index_approved: true`.
2. Require strict consistency between the index, task files, filenames, numbering, and statuses before implementation.
3. Block on extra `.task.md` files not declared in the index.
4. Block on missing declared task files.
5. Block on mismatched task IDs, filenames, numbering, phases, or statuses between the index and task files.
6. Require `contract_ready: true` before executing a task.
7. Execute tasks in index order unless the selected mode narrows the target while still preserving all prior required order.
8. Use `in_progress` before changing code for a task.
9. Keep task status synchronized in the index table and the task file frontmatter.
10. Derive phase and global index statuses from task execution state.
11. Mark a task `done` only after its `Acceptance Contract` passes and the implementation respects `Change Scope`, `Contract Shapes`, and `Relevant Rules`.
12. When the final task of a phase becomes `done`, run or confirm the phase `Functional Verification` before marking the phase `done`.
13. If phase verification fails after tasks are done, keep completed tasks `done`, mark the phase and index `blocked`, stop, and report the issue.
14. If a task blocks, mark the task, phase, and index `blocked`, stop the workflow, and report using the task's `Blocked Protocol`.
15. Do not modify the Plan from this workflow.
16. Do not modify task contracts or create new tasks from this workflow.
17. If redirection or redesign is needed, report the issue and recommend `/write-plan` or `/write-tasks` as appropriate.
18. Never modify a task with `status: done` except when reading it to derive state. If a completed task is affected by later redesign, that redesign must add a new adjustment task through the appropriate workflow.
19. Do not introduce dependencies unless the selected task explicitly permits that dependency work or the task itself is a dependency/setup task.
20. Do not change public signatures, shapes, architecture, functional behavior, dependencies, or files outside `Change Scope` unless explicitly allowed by the task contract.

## When To Use This Skill

Use this skill when:

- the user says `/implement`,
- the user asks to implement the next pending RedlineSpec task,
- the user asks to implement a specific task from `.redline/project/specs/<change>/tasks/`,
- the user asks to implement a phase,
- the user asks to implement all remaining tasks for a change,
- or approved task contracts need to be executed.

## Preconditions

Before executing any task, confirm all of these:

- the task index exists at `.redline/project/specs/<change>/tasks/<change>.tasks.md`,
- the index frontmatter has `index_approved: true`,
- every task declared in the index has a matching flat `*.task.md` file under the same `tasks/` directory,
- there are no extra `.task.md` files in the directory that are not declared in the index,
- index order and file numbering match strictly,
- task IDs, phases, filenames, and statuses match between index and task files,
- the selected task has `contract_ready: true`,
- the selected task is `pending` or objectively recoverable from `blocked`,
- any existing `in_progress` task is resumed before new `pending` work,
- and the requested mode does not violate index order.

If any precondition fails, do not implement. Block and report the inconsistency with concrete options and a recommended recovery path.

## Modes

The user does not need to use rigid subcommands. Infer the mode from the user's request.

Supported modes:

- `next`: default when the user says `/implement` without a narrower or broader scope.
- `task <id>`: execute one specific task, such as `P01-T03`.
- `phase <id>`: execute remaining eligible tasks in one phase, such as `P02`.
- `all`: execute all remaining eligible tasks for the change.

Do not expose `parallel_group` as a user-facing mode. Treat `parallel_group` as execution metadata for harnesses that can safely parallelize consecutive tasks.

### Mode Order Rules

For `next`, select the first executable task by index order.

For `task <id>`, execute the requested task only if all earlier required tasks are `done`. If earlier tasks are not done, block and report the earliest task that must run first.

For `phase <id>`, execute that phase only if all prior phases are `done`. Within the phase, execute remaining eligible tasks in order.

For `all`, start at the first eligible task and continue in index order until all work is done or a block occurs.

If any task is already `in_progress`, resume that task before selecting pending work, provided the requested mode can legally include it. If it cannot, block and report the active task.

## Workflow

Follow this sequence.

### Step 1: Determine target change and mode

Identify the `<change>` and requested mode from the user request and available task documents.

If multiple task indexes could apply, ask the user to choose one.

If the mode is omitted, use `next`.

### Step 2: Load and validate the task index

Read the full task index.

Validate:

- frontmatter fields needed for execution,
- `index_approved: true`,
- phase order,
- phase statuses,
- task table order,
- task IDs,
- task statuses,
- task filenames,
- and consecutive `parallel_group` usage.

If a `parallel_group` is present, mention that the group is parallelizable metadata. Continue serially unless the harness explicitly supports safe parallel task execution.

### Step 3: Validate filesystem consistency

List the `tasks/` directory and compare it to the index.

Block if:

- a declared task file is missing,
- an undeclared `.task.md` file exists,
- a declared filename does not match the task's phase/task numbering,
- task file frontmatter disagrees with the index,
- or any task status differs between index and task file.

Report inconsistencies with options for the user, such as using `/write-tasks` to regenerate incomplete pending contracts, removing accidental extra files, or manually resolving interrupted state.

### Step 4: Select the executable task or task range

Apply the selected mode and order rules.

If a task is `blocked`, do not retry it unless the cause of the block can be objectively verified as gone without changing the contract. If the cause is objectively gone, change the task and index status back to `pending`, derive phase/global status, then continue if the mode and order allow it.

If the selected task has `contract_ready: false`, block and recommend `/write-tasks`.

### Step 5: Load the selected task contract

Read the selected task file before editing code.

Use the task file as the execution contract.

Read repository files needed to understand and implement the task.

Only read upstream Spec, Plan, or rule files when the selected task is insufficient, contradictory, disputed, or blocked. If upstream reading reveals a contradiction or required contract change, block instead of improvising.

### Step 6: Mark task in progress

Before changing implementation files, update:

- task file frontmatter `status: in_progress`,
- the corresponding task row status in the index,
- the phase status in the index,
- and the global index frontmatter status.

Use the status derivation rules below.

### Step 7: Implement within contract

Make the smallest correct repository changes that satisfy the task contract.

Stay inside `Change Scope`.

Respect `Contract Shapes` and `Relevant Rules`.

Local implementation details may be resolved without blocking when they remain inside `Change Scope` and do not alter functional behavior, public signatures, relevant shapes, architecture, dependencies, or out-of-scope files.

Automatically generated changes from existing project tooling, such as formatters, snapshots, generated code, or lockfiles, may be allowed when they are a direct consequence of standard project commands, do not introduce a new dependency, and do not change the contract. Report them if they are relevant.

Block if the implementation requires:

- functional behavior outside the task or phase contract,
- public signature or shape changes beyond `Contract Shapes`,
- architecture changes,
- new dependencies not explicitly allowed by the task,
- files or areas outside `Change Scope`,
- changing the Plan,
- modifying task contracts,
- or creating new tasks.

### Step 8: Verify the task

Before marking the task `done`, verify:

- every item in `Acceptance Contract`,
- that actual file changes are within `Change Scope`, except allowed generated consequences,
- that public surfaces match `Contract Shapes`,
- and that implementation follows `Relevant Rules`.

You may run additional reasonable no-regression checks when the change could structurally break the project, such as targeted test suites, type checks, lint checks, or builds. These checks do not replace the task contract. If they reveal a real regression or structural failure, block instead of marking `done`.

If verification cannot run because of environment, dependency, or tooling problems, mark the task `blocked` and stop. Do not mark `done` based on confidence alone.

Internal project commands needed for verification may be executed. Installing or adding a dependency is allowed only if the selected task explicitly includes that dependency/setup work.

### Step 9: Mark task done or blocked

If the task passes verification, update:

- task file frontmatter `status: done`,
- the corresponding task row status in the index,
- the phase status,
- and the global index status.

Do not add evidence sections or execution notes to the task file.

If the task blocks, update:

- task file frontmatter `status: blocked`,
- the corresponding task row status in the index,
- the phase status,
- and the global index status.

Then stop and report using the blocked report format below.

### Step 10: Close the phase when applicable

If the completed task was the last unfinished task in its phase, run or confirm the phase `Functional Verification` before marking the phase `done`.

If phase verification is automatic, execute it.

If phase verification is manual or requires human judgment, provide concrete verification steps and ask for confirmation. If confirmation is not available, stop without marking the phase `done`.

If phase verification passes or is confirmed, mark the phase `done` and derive the global index status.

If phase verification fails, keep completed tasks `done`, mark the phase and global index `blocked`, stop, and report the failure. Recommend `/write-plan` or `/write-tasks` when the failure indicates missing or wrong contracts.

### Step 11: Continue or stop according to mode

For `next`, stop after the selected task and any required phase closeout.

For `task <id>`, stop after that task and any required phase closeout.

For `phase <id>`, continue through the phase until it is done, blocked, or waiting for manual phase verification. Stop after the phase is completed.

For `all`, continue across phases until all phases are done, blocked, or waiting for required human confirmation. `all` is an explicit one-shot attempt and may continue automatically after completed phases.

## Status Derivation

Use these status values only:

- `pending`
- `in_progress`
- `blocked`
- `done`

Task status lives in both the task file frontmatter and the task row in the index. They must match.

Phase status is derived from the tasks in that phase:

- `blocked` if any task is `blocked` or phase verification fails,
- `in_progress` if any task is `in_progress`,
- `done` if all tasks are `done` and phase `Functional Verification` passed or was confirmed,
- `in_progress` if all tasks are `done` but phase `Functional Verification` is still pending or waiting for human confirmation,
- `in_progress` if at least one task is `done` and at least one task remains `pending`,
- otherwise `pending`.

Global index status is derived from phases:

- `blocked` if any phase is `blocked`,
- `in_progress` if any phase is `in_progress`,
- `done` if all phases are `done`,
- otherwise `pending`.

## Blocked Report Format

When blocking, report in a structured form.

Include:

- blocking reason,
- evidence observed,
- affected contract section,
- relevant files or artifacts,
- options available to the user,
- recommended option,
- and suggested workflow, such as `/write-plan` or `/write-tasks`, when redesign is needed.

When the block is caused by index/filesystem inconsistency, provide options in an interview-like style so the user can choose the recovery path.

When the block is caused by a task's `Blocked Protocol`, follow that protocol exactly and include any additional context needed to preserve the implementation handoff.

## What Not To Do

Do not:

- execute an unapproved task index,
- execute a task with `contract_ready: false`,
- skip earlier required tasks,
- retry `blocked` work unless the block cause is objectively gone,
- mark a task `done` without verifying its contract,
- mark a phase `done` without phase functional verification,
- add evidence/log/result sections to task files,
- update the final Spec,
- update functional truth,
- edit the Plan,
- create or rewrite task contracts,
- create new tasks,
- modify tasks with `status: done`,
- introduce undocumented dependencies,
- or normalize contract deviations by editing scope, shapes, or task text.

## Output Expectations

A good result from this workflow is:

- repository code changed only as allowed by the selected task contract,
- task and index statuses synchronized,
- phase and global index statuses derived correctly,
- task-level verification completed before `done`,
- phase-level functional verification completed or explicitly waiting for human confirmation,
- no new task template sections introduced,
- and a clear final report of what was completed or why the workflow blocked.

## Final Checklist

Before finishing, confirm all of these:

- The task index was approved.
- Index and filesystem consistency were checked.
- The selected mode preserved task order.
- Every executed task had `contract_ready: true`.
- Every executed task was marked `in_progress` before implementation.
- No task contract was modified except status frontmatter.
- The index task row status matches each executed task file status.
- Phase and global statuses were updated from task state.
- `Acceptance Contract`, `Change Scope`, `Contract Shapes`, and `Relevant Rules` were verified before `done`.
- Phase `Functional Verification` was handled when a phase completed.
- No final Spec or functional truth update was attempted.
