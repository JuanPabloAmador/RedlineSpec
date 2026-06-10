# RedlineSpec Skills Catalog

RedlineSpec exposes a small set of portable Agent Skills. The skills are the canonical user-facing operational surface; harness-specific commands, workflows, or launchers are not part of the canonical interface.

## 1. General principle

RedlineSpec's operational interface separates these responsibilities:

- orienting the agent to the framework,
- checking framework health,
- bootstrapping persistent functional truth,
- discovering and aligning context,
- writing functional contracts,
- writing technical contracts and persistent rules,
- implementing work from `Tasks`,
- closing and merging implemented functional change.

That separation is expressed through this skill catalog:

- `redlinespec`
- `health-check`
- `bootstrap-functional-truth`
- `interview`
- `write-spec`
- `write-plan`
- `write-rules`
- `write-tasks`
- `implement`
- `close-spec`
- `merge-functional-truth`

Internal orchestration details are outside the scope of this document. This catalog defines which skill should be activated for each RedlineSpec operation.

## 2. Initial catalog

### 2.1 `redlinespec`

Provides minimal framework orientation and helps choose the next RedlineSpec workflow.

Use it when the user or agent needs to understand whether a request belongs in the RedlineSpec flow, or which workflow skill should be activated next.

Expected result: a routing decision, not a project document.

### 2.2 `health-check`

Verifies framework installation integrity, documentation structure, functional truth organization, rules health, and spec lifecycle hygiene.

Use it after installation, after framework updates, or when functional truth and rules may have drifted over time.

Expected result: a standardized health-check report that another agent can use as a repair plan.

### 2.3 `bootstrap-functional-truth`

Creates or refines the initial living functional truth after RedlineSpec has been installed in a project.

Use it when `functional.index.md` still has no useful baseline, when a repository needs high-level functional area discovery, or when a bounded repository can have its current behavior documented directly into `*.entry.md` and `*.global.entry.md` files.

Expected result: an updated `.redline/project/functional-truth/` baseline with explicit coverage and documentation gaps.

`bootstrap-functional-truth` is not the installer and does not merge implemented specs.

### 2.4 `interview`

Gathers the necessary context and aligns understanding between the user and the agent before drafting any contract.

Use it at the beginning of the flow, when the problem, goal, scope, or type of artifact to produce still needs clarification.

Expected result: enough shared understanding to draft the next step, which may be `write-spec`, `write-plan`, `write-rules`, or `write-tasks`.

### 2.5 `write-spec`

Drafts a `Spec` contract from the context already obtained.

Use it when, after context gathering, the functional change should be formalized as a specification.

Expected result: a complete `*.spec.md`, ready to serve as the basis for later phases.

### 2.6 `write-plan`

Drafts a `Plan` contract from the context already obtained.

Use it when the next step is to define how to technically approach an already understood `Spec`.

Expected result: a compact `*.plan.md` index describing technical blocks plus linked technical unit files containing signatures, shapes, dependencies, affected areas, and applicable rules.

### 2.7 `write-rules`

Creates or updates the project's persistent implementation rules.

Use it after the initial functional truth baseline when the project should capture reusable implementation constraints before the first planned implementation flow. It can also be used later whenever the project needs to add a new rule, refine existing rules, or keep `rules.index.md` aligned.

Rules are not every persistent project decision. They should constrain how future agents write, modify, verify, or approve code, not restate stack choices, tool settings, release procedures, documentation, or collaboration preferences.

`write-rules` is recommended but not mandatory. A project can continue without rules, but `write-plan` should warn before drafting a technical contract when no project rules are currently defined.

Expected result: an updated `rules.index.md` and the required `*.rule.md` files inside `.redline/project/rules/`.

### 2.8 `write-tasks`

Drafts `Tasks` contracts from the context already obtained.

Use it when the technical plan should be transformed into concrete, executable work.

Expected result: the `Tasks` structure required to implement the change:

- an operational index `<change>.tasks.md`,
- functionally verifiable vertical phases,
- and one `*.task.md` file for each task.

The index is created and approved first. The individual task files are generated afterward, possibly by phases or sessions when the set is large.

The official task-writing workflow must use:

- `.redline/system/templates/tasks.template.md`,
- `.redline/system/templates/task.template.md`,
- and the harness-visible `write-tasks` skill installed for the active agent.

`write-tasks` only writes contracts. It does not implement code or update the final functional truth.

### 2.9 `implement`

Implements or executes approved `Tasks` contracts.

Use it when an approved task index already exists and the next step is to move the work into code or effective execution.

Expected result: real implementation progress as defined by `Tasks`, keeping the statuses in the index and in the `*.task.md` files synchronized.

By default, it executes the next valid pending task. It can also operate on a specific task, a phase, or all remaining tasks when the user explicitly asks for it.

`implement` does not rewrite contracts, does not update the final `Spec`, and does not consolidate the living functional truth.

### 2.10 `close-spec`

Verifies implementation evidence against a `Spec`, aligns the `Spec` with what was actually implemented, and marks it `implemented` when evidence is sufficient.

Use it after implementation is complete and before functional truth consolidation.

Expected result: one updated `*.spec.md` with `Implemented Result`, `Implementation Summary`, `Relevant Differences from Proposed Change`, and `Impact on Functional Truth`.

`close-spec` does not modify application code and does not update functional truth.

### 2.11 `merge-functional-truth`

Consolidates one or more implemented specs into the living functional truth.

Use it only after every spec in the merge set has been closed by `close-spec` or otherwise satisfies the same implemented-spec contract.

Expected result: updated `functional.index.md`, updated or created `*.entry.md` and `*.global.entry.md` files, and removal of the successfully merged temporary spec folders.

`merge-functional-truth` blocks if a spec is not closed or if the merge has semantic conflicts.

## 3. Expected flow

The recommended operational sequence for a first project flow is:

```txt
redlinespec                (when orientation or routing is needed)
   |
   v
health-check               (after install/update or when drift is suspected)
   |
   v
bootstrap-functional-truth  (when the project needs an initial baseline)
   |
   v
write-rules                 (recommended after initial baseline; optional)
   |
   v
interview
   |
   v
write-spec -> write-plan -> write-tasks
   |
   v
implement
   |
   v
close-spec
   |
   v
merge-functional-truth
```

`bootstrap-functional-truth` prepares the persistent baseline when needed.

`write-rules` is the recommended next startup step for capturing persistent project implementation constraints. It may be skipped explicitly, and it may be run again later as the project discovers new reusable constraints.

`interview` opens a specific change flow.

The change-writing workflow skills then create the required contracts for the current change. Simple changes may stop at `Spec`; planned changes continue through `Plan` and `Tasks`.

`implement` consumes `Tasks`; it does not write a new contract.

`close-spec` closes the functional branch after implementation.

`merge-functional-truth` merges that branch back into the living functional truth and removes temporary change documents.

## 4. Relationship with the main flow

This catalog describes how the user activates the framework through Agent Skills.

The document structure and the rules between `Spec`, `Plan`, `Rules`, `Tasks`, and `Implementation` are defined in:

- `docs/en/main-flow.md`
- `docs/en/documents.md`

## 5. Outside the 0.4.0 skill surface

The core RedlineSpec workflow is covered by the skills above.

The following concerns are intentionally outside the canonical skill surface:

- harness-specific UI affordances for manually invoking installed skills,
- automatic installation from specific agents or coding tools,
- and tool-specific command registration for Codex, Claude Code, OpenCode, Devin Desktop, or similar environments.

## 6. Operational summary

RedlineSpec's minimum Agent Skills surface is:

- `redlinespec` to orient and route to the next workflow,
- `health-check` to verify installation and documentation health,
- `bootstrap-functional-truth` to create or refine the initial functional baseline,
- `write-rules` to initialize or maintain persistent project implementation rules,
- `interview` to discover and align,
- `write-spec` to write `Spec`,
- `write-plan` to write `Plan`,
- `write-tasks` to write `Tasks`,
- `implement` to execute `Tasks`,
- `close-spec` to align the final `Spec` with implementation,
- `merge-functional-truth` to consolidate implemented specs into living functional truth.

This is RedlineSpec's official catalog of user-facing Agent Skills.
