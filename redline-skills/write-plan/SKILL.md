---
name: write-plan
description: >-
  RedlineSpec workflow skill for write-plan. Also use for create plan, technical implementation plan, technical contract, and plan technical units. Use this workflow skill to translate an already-understood functional change or Spec into a repo-aware technical Plan with implementation structure, affected areas, signatures, dependencies, technical units, and rules references. Do not use for functional discovery, writing the Spec itself, task decomposition, code implementation, functional truth updates, or generic project planning.
---

# RedlineSpec write-plan Workflow

Use this skill to execute the operational workflow for writing a RedlineSpec `Plan`.

This is a workflow skill.

It tells you what to read, what to infer from the repo, when to ask follow-up questions, and how to write the final technical contract.

## Read First

Before doing anything else, read these files:

- `.redline/system/templates/plan.template.md`
- `.redline/system/templates/plan-technical-unit.template.md`

When available, also read:

- the source `*.spec.md`
- the relevant code areas of the repository
- `.redline/project/rules/rules.index.md`
- the specific `*.rule.md` files likely to be referenced by the plan
- any supporting context documents already mentioned by the user

This workflow must stay portable. At runtime it should depend only on the distributed template, the rules embedded in this skill, the project documents, and the repository itself.

Template resolution is installation-relative: locate the target project root that contains `.redline/system/templates/`, then read templates from that directory. If `.redline/system/templates/plan.template.md` or `.redline/system/templates/plan-technical-unit.template.md` is missing, stop and report that the RedlineSpec system installation is incomplete or must be refreshed.

## Purpose of write-plan

`write-plan` exists to turn an already-understood change into a technical implementation contract.

The `Plan` defines the how.

It does not restate the functional what from the `Spec`. It translates that functional contract into a technical index plus technical unit contracts covering structure, signatures, dependencies, affected areas, and applicable rules.

A RedlineSpec `Plan` is:

- technical,
- repo-aware,
- signature-first,
- structured for agents,
- readable for programmers,
- and detailed enough to drive later task creation and implementation.

## Embedded Contract Rules

Always apply these rules:

1. Keep the plan technical, not functional.
2. Do not restate the `Spec` unless a small amount of functional context is strictly needed to explain a technical decision.
3. The plan defines how the change will be built: components, services, endpoints, modules, models, interfaces, signatures, dependencies, and technical decomposition.
4. The plan is optional in the overall framework flow, but once you are writing one, do not encode that optionality inside the document itself.
5. Do not turn the plan into a task timeline or execution sequence. Temporal decomposition belongs to `Tasks`.
6. Use the exact section names and overall shapes from `.redline/system/templates/plan.template.md` and `.redline/system/templates/plan-technical-unit.template.md`.
7. Keep the entire plan in English.
8. Use the source `Spec` as the upstream contract, but do not force the technical decomposition to mirror the functional block structure.
9. Every technical block must trace the functional blocks it resolves via `Resolves`.
10. Detailed signatures and shapes live in technical unit files, not in the plan index or at block level.
11. Write technical units as cohesive modules: one technical unit per module/capability — a graph node such as a login service, admin console, checkout flow, or other bounded behavior — not per file. A TU may constrain one or more tightly cohesive artifacts that share responsibility, invariants, and lifecycle; do not fragment a cohesive module across TUs merely because it spans multiple files. File-level atomicity belongs to Tasks, not to the Plan.
12. A `ready` Plan must cover the source Spec's in-scope functional obligations through technical blocks and responsibilities.
13. Validate Spec coverage through `Resolves`, block responsibilities, and technical unit contracts.
14. Every technical block must include a `Rules` subsection, even if it only contains `- None.`.
15. `Plan-Wide Context` is conditional. When present, use only these subsections: `Shared Decisions`, `Open Questions`, `Rules`, `Supporting Context`.
16. Supporting documents must be linked explicitly and accompanied by a short description.
17. Rules referenced by the plan must point to real project rule files under `.redline/project/rules/`.
18. The plan references rules; it does not inline or expand them.
19. If technical open questions remain, keep the plan at `draft`.
20. `ready` means the technical contract is sufficiently closed for later task generation or direct technical execution.
21. Do not include code bodies or pseudocode-heavy implementations.
22. Prefer signatures, shapes, responsibilities, and dependencies over internal algorithm narration.
23. Inspect the real repository before claiming affected areas or artifacts.
24. If planning reveals a new functional decision, functional constraint, or discovered behavior that changes or refines the source Spec, do not hide it in the Plan as a technical decision. Add or update a temporary `## Consolidation Notes` section in the source Spec with a concise `CN-*` entry.
25. Use Consolidation Notes only for functional discoveries. Technical decisions remain in the Plan.
26. When adding a Consolidation Note, use this format: `- **CN-N:** Concise functional decision or discovery.`, followed by `Origin:` and `Impact:` sub-bullets. If the section does not exist, insert it between `## Global Constraints and Conditions` and `## Functional Blocks`. If it already exists, append the next `CN-*` entry.

## When To Use This Skill

Use this skill when:

- the user wants to create a new RedlineSpec `Plan`,
- the user says `write-plan`,
- a `Spec` already exists and now needs a technical contract,
- or an existing draft plan must be completed or refined.

## Preconditions

This workflow assumes there is enough context to define the technical solution.

At minimum, you should be able to determine:

- the source `Spec`,
- the real repo areas involved,
- the technical decomposition into blocks,
- the main technical units,
- the signatures or shapes that constrain implementation,
- and the applicable project rules.

If that information is not yet available, do not guess.

Ask only the minimum necessary follow-up questions, one at a time.

## Non-Goals

Do not use this workflow to:

- write or revise the functional `Spec`,
- produce `Tasks`,
- implement code,
- or define the post-implementation update of the `Spec`.

## Workflow

Follow this sequence.

### Step 1: Load the contract shape

Read:

- `.redline/system/templates/plan.template.md`
- `.redline/system/templates/plan-technical-unit.template.md`

Treat those templates and the rules embedded in this skill as canonical.

### Step 2: Load the upstream context

Read the source `Spec`.

Expected canonical location:

- `.redline/project/specs/<change>/<change>.spec.md`

Also inspect the relevant repository code and any existing supporting context files.

### Step 3: Load project rules

Check the project rules state under:

- `.redline/project/rules/`

Treat project rules as active only when at least one real `*.rule.md` file exists.

If the project has active rules, read:

- `.redline/project/rules/rules.index.md`

Then read the specific `*.rule.md` files likely to apply to the plan.

If the project has no active rules yet:

- warn clearly that no project rules are currently defined or active,
- explain that planning can continue, but `write-rules` is recommended first because rules improve the technical contract and later task contracts,
- ask whether the user wants to continue with the plan anyway or pause to run `write-rules`, unless the user already explicitly chose to skip rules for this plan,
- use `Rules` subsections carefully,
- and do not invent fake rule file paths.

If a missing rule is required before the plan can be confidently marked `ready`, keep the plan at `draft` or recommend `write-rules`.

### Step 4: Check whether technical context is sufficient

You need enough information to write:

- `Affected Areas`,
- optional `Plan-Wide Context`,
- and at least one `Technical Block` with declared technical unit files.

You must also be able to answer, technically:

- what repo areas are touched,
- what new artifacts are introduced,
- how the change is decomposed,
- what signatures and shapes constrain implementation,
- and what rules apply.

If any of that is missing, ask focused follow-up questions before writing.

### Step 5: Determine file identity and path

The canonical project path is:

- `.redline/project/specs/<change>/plan/<change>.plan.md`

Technical unit contracts live under:

- `.redline/project/specs/<change>/plan/technical-units/tu-01-<slug>.plan.md`

Rules:

- use the same change base name as the source spec,
- derive `id` from that change base name,
- and set `spec` to the real repository path of the source spec.

### Step 6: Decide status

Allowed values:

- `draft`
- `ready`

Rules:

- use `draft` if open technical questions remain,
- use `ready` only when the technical contract is sufficiently closed,
- do not hide open questions in prose.

Global open questions belong in `Plan-Wide Context > Open Questions`.
Block-level open questions belong in the corresponding technical block.
Unit-level open questions belong in the corresponding technical unit file.

### Step 7: Write `Affected Areas`

This section is mandatory.

It must contain:

- `Existing Areas to Change`
- `New Artifacts to Create`

Group each subsection by technical domain such as:

- `UI`
- `Server`
- `Model`
- `API`
- `Shared`
- `Database`

Rules:

- this section gives a global repo-aware view,
- it is not the place for signatures,
- and it should not collapse into a block-by-block duplicate.

### Step 8: Write `Plan-Wide Context` when needed

This section is conditional.

Only include it when there is plan-wide material that affects multiple technical blocks.

Allowed subsections:

- `Shared Decisions`
- `Open Questions`
- `Rules`
- `Supporting Context`

Rules:

- `Shared Decisions` = common technical decisions affecting multiple blocks,
- `Open Questions` = unresolved global technical questions,
- `Rules` = plan-wide project rule references using real paths plus titles,
- `Supporting Context` = links to supporting files plus a short description.

Omit any subsection that does not apply.

### Step 9: Decompose the solution into `Technical Blocks`

This is the core of the plan.

Technical blocks are technical, not functional.

They may group one technical unit or several closely related units, but they must remain coherent implementation units. Think of blocks and units as graph nodes: a block is a coarse capability area (e.g., `Auth`), a TU is a cohesive module inside it (e.g., `Login Service`, `Admin Console`, `Session Store`) with explicit `Dependencies` edges to other TUs. If you can draw the system's module graph, each TU should be one node.

Each block must include:

- `TB-*` ID and title,
- `Change Type: add | modify | remove`,
- `Affected Areas`,
- `Resolves`,
- `Artifacts`,
- `Responsibility`,
- `Technical Units`,
- optional `Open Questions`,
- mandatory `Rules`,
- optional `Supporting Context`.

Rules:

- `Affected Areas` at block level list the technical domains touched by the block,
- `Artifacts` list conceptual code artifacts such as components, services, controllers, endpoints, repositories, models, modules, or similar,
- `Resolves` must reference the functional block IDs from the source `Spec`,
- `Responsibility` defines the technical responsibility of the block as a unit.

### Step 10: Write `Technical Units` correctly

`Technical Units` are mandatory in every technical block.

In the plan index, `Technical Units` is a navigation table.

Each technical unit row must define:

- `Unit` ID such as `TU-01`
- `Type`
- `File`
- `Contract Summary`

Each technical unit file must define:

- `Source Trace`
- `Responsibility`
- `Affected Artifacts`
- `Inputs`
- `Outputs`
- `Dependencies`
- `Public Surface`
- `Key Internal Functions`
- `Contract Shapes`
- `Relevant Rules`
- optional `Supporting Context`
- optional `Open Questions`

Rules:

- keep unit contracts implementation-constraining but code-free,
- use stable `TU-*` IDs across the whole plan,
- use file names such as `technical-units/tu-01-<slug>.plan.md`,
- define real shapes where they matter,
- show public and important internal signatures,
- use `Dependencies` to make the module graph explicit: each TU declares the other TUs/modules it collaborates with or depends on (injection, import, event, data flow), so the whole Plan can be drawn as a directed graph,
- and do not hide crucial structure in vague prose.

Atomicity and modularity rules:

- write one technical unit per cohesive module/capability, not per file: a TU is a graph node with a single responsibility and a coherent lifecycle (e.g., `Login Service`, `Admin API`, `Session Module`), even when it owns several files/artifacts (component + hook + service + types that move together),
- group tightly cohesive artifacts into the same TU when they share invariants, state, or a single public surface; splitting them across TUs would hide coupling,
- a technical block may group several related TUs (e.g., `TB-01 Auth` groups `TU-01 Login Service` + `TU-02 Session Store`), but the units themselves remain module-level, not file-level,
- when a module comes with tests or specs, decide explicitly whether the tests live in the same TU or as a `TU` of type `test`, keeping one clear responsibility per TU,
- file-level atomicity is the job of `write-tasks`: a single TU will later be decomposed into one or more tasks, each covering one artifact or one small vertical slice of that module.

### Step 11: Write `Rules` correctly

At plan index level, block level, or technical unit level, each rule entry must contain:

- the real path to the rule file,
- and the human-readable title.

Recommended format:

- `` `.redline/project/rules/ui-some-rule.rule.md` — UI some rule title ``

Rules:

- block-level `Rules` are mandatory in the plan index,
- unit-level `Relevant Rules` are mandatory in technical unit files,
- if no specific rule applies beyond broader context, write `None.`,
- do not inline rule bodies in the plan.

### Step 12: Link supporting context

When a supporting document materially helps explain a global or local technical choice, link it explicitly.

Rules:

- use a real file path link,
- accompany it with a brief description,
- do not paste the full supporting document into the plan.

### Step 13: Validate readiness

Before finalizing, verify:

- the plan is technical rather than functional,
- the document is fully in English,
- the frontmatter is complete,
- the source `Spec` path is real,
- the Plan covers every in-scope functional obligation from the source `Spec`,
- the technical decomposition is repo-aware,
- every block has `Resolves`, `Artifacts`, `Responsibility`, `Technical Units`, and `Rules`,
- every technical unit listed in the plan index has a corresponding file,
- every technical unit file is `ready` when the plan index is `ready`,
- every technical unit file has signatures or shapes detailed enough to constrain implementation,
- global and local open questions are not hidden,
- and rules reference real project rule files or explicitly remain absent.

Validate Spec-to-Plan coverage by checking the source Spec's functional blocks, requirements, and acceptance material against the Plan index's `Resolves`, block responsibilities, artifacts, and linked technical unit contracts. If any functional obligation is not technically addressed, keep the Plan at `draft` and state the missing coverage as an open question or required revision.

If open technical questions remain, keep the plan at `draft`.

### Step 14: Write or update the file

Create or update:

- `.redline/project/specs/<change>/plan/<change>.plan.md`
- `.redline/project/specs/<change>/plan/technical-units/tu-01-<slug>.plan.md`

Create `.redline/project/specs/<change>/plan/technical-units/` when technical unit files are written.

If the user asked only for the content first, present the draft before writing. Otherwise write the plan index and technical unit files directly when appropriate.

## Special Case: Updating an Existing Plan During Implementation

If the user wants to revise a plan mid-implementation:

1. read the current plan,
2. read the affected technical unit files,
3. preserve valid block and unit structure where possible,
4. change only the technical contract that truly needs to move,
5. keep `Rules` and `Relevant Rules` references aligned,
6. keep open questions explicit,
7. and do not create a post-implementation closing section.

A `Plan` may change during implementation if the technical contract must be realigned, but it is not closed after implementation in the same way as a `Spec`.

## Output Expectations

A good result from this workflow is:

- one valid `*.plan.md`,
- valid technical unit files under `plan/technical-units/` where each TU is a module-level node that can be drawn in a dependency graph,
- technical and repo-aware,
- centered on blocks (capability areas) and technical units (cohesive modules),
- rich in signatures and shapes at TU level,
- light on narrative duplication,
- modular (Plan) with a clear path to file-level decomposition (Tasks),
- and ready to feed later task generation.

## Final Checklist

Before finishing, confirm all of these:

- The source `Spec` exists and is correctly referenced.
- The plan path follows `.redline/project/specs/<change>/plan/<change>.plan.md`.
- Technical unit files live under `.redline/project/specs/<change>/plan/technical-units/`.
- `id` matches the change base name.
- The plan is fully in English.
- plan and technical unit `status` values are `draft` or `ready`.
- `Affected Areas` is present and grouped correctly.
- `Plan-Wide Context` appears only when needed.
- Every technical block uses `TB-*` IDs.
- The Plan covers the source Spec's in-scope functional obligations through its technical blocks and units.
- Every block has `Change Type`, `Affected Areas`, `Resolves`, `Artifacts`, `Responsibility`, `Technical Units`, and `Rules`.
- Every technical unit listed in the index has a matching file.
- Every technical unit file is `ready` when the plan index is `ready`.
- Every technical unit file defines the required signature-first fields.
- Block `Rules` exists even when the content is `- None.`.
- Supporting documents are linked rather than pasted.
- No block relies on code bodies to explain its contract.
- No hidden technical ambiguity remains if the plan is `ready`.

## What Not To Do

Do not:

- rewrite the `Spec` in technical prose,
- organize the plan around implementation timeline,
- omit technical signatures when they are needed to constrain the build,
- atomize the plan per file — that granularity belongs to task decomposition, not to the plan,
- collapse multiple technical units into vague narrative,
- collapse a cohesive module into several file-level TUs that hide its coupling,
- inline rule content instead of referencing rule files,
- mark the plan `ready` while open technical questions remain,
- or use the plan as a post-implementation report.

## Next Workflow

When this workflow finishes, tell the user the next step is to run `write-tasks`.
