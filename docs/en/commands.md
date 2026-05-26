# RedlineSpec Commands

RedlineSpec exposes a minimal user-facing command surface to activate its flow without requiring the user to understand the internal orchestration.

This document defines the initial command catalog officially recognized by the framework.

## 1. General principle

RedlineSpec's operational interface separates these responsibilities:

- bootstrapping persistent functional truth,
- discovering and aligning context,
- writing functional contracts,
- writing technical contracts and persistent rules,
- implementing work from `Tasks`,
- closing and merging implemented functional change.

That separation is expressed in a small command catalog:

- `/bootstrap-functional-truth`
- `/interview`
- `/write-spec`
- `/write-plan`
- `/write-rules`
- `/write-tasks`
- `/implement`
- `/close-spec`
- `/merge-functional-truth`

Internal orchestration details are outside the scope of this document. This only defines the surface the user activates directly.

## 2. Initial catalog

### 2.1 `/bootstrap-functional-truth`

Its purpose is to create or refine the initial living functional truth after RedlineSpec has been installed in a project.

It should be used when `functional.index.md` still has no useful baseline, when a repository needs high-level functional area discovery, or when a bounded repository can have its current behavior documented directly into `*.entry.md` and `*.global.entry.md` files.

Its expected result is an updated `.redline/project/functional-truth/` baseline with explicit coverage and documentation gaps.

`/bootstrap-functional-truth` is not the installer and does not merge implemented specs.

### 2.2 `/interview`

Its purpose is to gather the necessary context and align understanding between the user and the agent before drafting any contract.

It should be used at the beginning of the flow, when the problem, goal, scope, or type of artifact to produce still needs clarification.

Its expected result is enough shared understanding to draft the next step, which may be `/write-spec`, `/write-plan`, `/write-rules`, or `/write-tasks`.

### 2.3 `/write-spec`

Its purpose is to draft a `Spec` contract from the context already obtained.

It should be used when, after `/interview`, the functional change should be formalized as a specification.

Its expected result is a complete `*.spec.md`, ready to serve as the basis for later phases.

### 2.4 `/write-plan`

Its purpose is to draft a `Plan` contract from the context already obtained.

It should be used when, after `/interview`, the next step is to define how to technically approach an already understood `Spec`.

Its expected result is a `*.plan.md` describing technical blocks, technical units, signatures, shapes, dependencies, affected areas, and applicable rules.

### 2.5 `/write-rules`

Its purpose is to create or update the project's persistent rules.

It should be used when the project needs to initialize its rules catalog, add a new rule, refine existing rules, or keep `rules.index.md` aligned.

Its expected result is an updated `rules.index.md` and the required `*.rule.md` files inside `.redline/project/rules/`.

### 2.6 `/write-tasks`

Its purpose is to draft `Tasks` contracts from the context already obtained.

It should be used when, after `/interview` or after `/write-plan`, the technical plan should be transformed into concrete, executable work.

Its expected result is the `Tasks` structure required to implement the change:

- an operational index `<change>.tasks.md`,
- functionally verifiable vertical phases,
- and one `*.task.md` file for each task.

The index is created and approved first. The individual task files are generated afterward, possibly by phases or sessions when the set is large.

The official task-writing workflow must use:

- `.redline/system/templates/tasks.template.md`,
- `.redline/system/templates/task.template.md`,
- and `.redline/system/skills/write-tasks/`.

`/write-tasks` only writes contracts. It does not implement code or update the final functional truth.

### 2.7 `/implement`

Its purpose is to implement or execute approved `Tasks` contracts.

It should be used when an approved task index already exists and the next step is to move the work into code or effective execution.

Its expected result is real implementation progress as defined by `Tasks`, keeping the statuses in the index and in the `*.task.md` files synchronized.

By default, it executes the next valid pending task. It can also operate on a specific task, a phase, or all remaining tasks when the user explicitly asks for it.

`/implement` does not rewrite contracts, does not update the final `Spec`, and does not consolidate the living functional truth.

### 2.8 `/close-spec`

Its purpose is to verify implementation evidence against a `Spec`, align the `Spec` with what was actually implemented, and mark it `implemented` when evidence is sufficient.

It should be used after implementation is complete and before functional truth consolidation.

Its expected result is one updated `*.spec.md` with `Implemented Result`, `Implementation Summary`, `Relevant Differences from Proposed Change`, and `Impact on Functional Truth`.

`/close-spec` does not modify application code and does not update functional truth.

### 2.9 `/merge-functional-truth`

Its purpose is to consolidate one or more implemented specs into the living functional truth.

It should be used only after every spec in the merge set has been closed by `/close-spec` or otherwise satisfies the same implemented-spec contract.

Its expected result is updated `functional.index.md`, updated or created `*.entry.md` and `*.global.entry.md` files, and removal of the successfully merged temporary spec folders.

`/merge-functional-truth` blocks if a spec is not closed or if the merge has semantic conflicts.

## 3. Expected flow

The minimum operational sequence is:

```txt
/bootstrap-functional-truth  (when the project needs an initial baseline)
   |
   v
/interview
   |
   v
/write-spec | /write-plan | /write-rules | /write-tasks
   |
   v
/implement
   |
   v
/close-spec
   |
   v
/merge-functional-truth
```

`/bootstrap-functional-truth` prepares the persistent baseline when needed.

`/interview` opens a specific change flow.

The `/write-*` commands write or update the appropriate contract depending on the current point in the work.

`/implement` consumes `Tasks`; it does not write a new contract.

`/close-spec` closes the functional branch after implementation.

`/merge-functional-truth` merges that branch back into the living functional truth and removes temporary change documents.

## 4. Relationship with the main flow

This catalog describes how the user activates the framework.

The document structure and the rules between `Spec`, `Plan`, `Rules`, `Tasks`, and `Implementation` are defined in:

- `docs/en/main-flow.md`
- `docs/en/documents.md`

## 5. Outside the 0.1.0 command surface

The core RedlineSpec workflow is covered by the commands above.

The following concerns are intentionally outside the 0.1.0 command surface:

- harness-specific bindings for invoking the distributed skills,
- automatic installation from specific agents or coding tools,
- and tool-specific command registration for Codex, Claude Code, opencode, or similar environments.

## 6. Operational summary

RedlineSpec's initial minimum surface is:

- `/bootstrap-functional-truth` to create or refine the initial functional baseline,
- `/interview` to discover and align,
- `/write-spec` to write `Spec`,
- `/write-plan` to write `Plan`,
- `/write-rules` to write `Rules`,
- `/write-tasks` to write `Tasks`,
- `/implement` to execute `Tasks`,
- `/close-spec` to align the final `Spec` with implementation,
- `/merge-functional-truth` to consolidate implemented specs into living functional truth.

This is RedlineSpec's initial official catalog of user-facing commands.
