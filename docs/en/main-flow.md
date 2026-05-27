# RedlineSpec Main Flow

RedlineSpec organizes work around a living functional truth, a persistent system of project technical rules, and a small set of temporary documents that allow the application to be modified in a controlled way.

This document describes when the flow is activated, what each step produces, and how the result is consolidated.

For the detailed definition of the document catalog, see `docs/en/documents.md`.

For the framework's user-facing operational interface, see `docs/en/commands.md`.

## 1. Starting point

A project's living functional truth consists of:

- `functional.index.md`
- `*.entry.md`
- `*.global.entry.md`

`functional.index.md` acts as the entry and routing point.

The `*.entry.md` files describe units of functional truth.

The `*.global.entry.md` files describe cross-cutting functional truth when it is useful to separate it into dedicated files.

This structure must favor progressive disclosure: small or medium-sized files that are easy to navigate and easy to load only when needed.

In addition to the functional truth, the project may maintain persistent technical rules under `.redline/project/rules/`. Those rules are not part of the functional truth, but they are part of the persistent context that `Plan` and `Tasks` can consume.

Creating an initial rules catalog is recommended after the functional truth baseline exists. It is not mandatory, because some projects or changes may not have reusable technical rules yet, but it gives the first technical planning step stronger project-specific constraints.

## 2. Flow activation

The framework's operational question is:

> Does this change modify existing functional truth or add new functional truth?

From that question there are two paths:

- If the answer is no, the change can be handled directly.
- If the answer is yes, the change enters the RedlineSpec flow.

## 3. Project startup

RedlineSpec must be able to start in both greenfield and brownfield projects.

The installer creates the minimum persistent structure, including `functional.index.md`.

After installation, startup refinement can take three shapes:

1. keep a minimal index when no functional behavior can be inferred yet,
2. identify high-level functional areas and mark discovery gaps when the repository is large or uncertain,
3. create `*.entry.md` and `*.global.entry.md` files when current functional truth is bounded and clear enough to document without guessing.

The result of startup is an initial functional truth, even if it is still partial.

At the user-facing command level, `/bootstrap-functional-truth` refines this startup baseline after installation. It can leave an empty project at a minimal indexed state, map large repositories at a high level with discovery gaps, or create detailed `*.entry.md` and `*.global.entry.md` files when the functional surface is bounded and clear.

After that baseline exists, `/write-rules` is the recommended next startup workflow for capturing persistent technical practices. This recommendation is non-blocking: the user may skip rules explicitly, and the project can add or refine rules later as reusable constraints become clear.

## 4. Change flow structure

Every change that enters the flow starts from the current functional truth and always goes through a `Spec`.

From there, the flow has two variants:

### Simple flow

```txt
Functional Truth
      |
      v
Spec
      |
      v
Implementation
      |
      v
Updated Spec
      |
      v
Updated Functional Truth
```

### Planned flow

```txt
Functional Truth
      |
      v
Spec
      |
      v
Plan
      |
      v
Tasks
      |
      v
Implementation
      |
      v
Updated Spec
      |
      v
Updated Functional Truth
```

The difference between the two variants is that `Plan` and `Tasks` only appear when the change needs to be translated into a more detailed technical solution.

At the user-facing command level, `/close-spec` updates the final `Spec` after implementation, and `/merge-functional-truth` consolidates implemented specs into the living functional truth.

## 5. What each step produces

### 1. Functional Truth

Uses:

- `functional.index.md`
- `*.entry.md`
- `*.global.entry.md`

Produces:

- the current functional baseline from which the change is opened.

### 2. Spec

Produces:

- `*.spec.md`

The `Spec` defines the functional change and acts as the functional branch of the work.

### 3. Plan

Produces:

- `*.plan.md`

This step is optional. It appears when the `Spec` must be translated into implementable technical contracts.

This is the first technical point where persistent project rules become important. The `Plan` can reference those rules to constrain the solution. If no rules are defined yet, planning can continue, but the workflow should warn the user and recommend `/write-rules` before finalizing the technical contract.

### 4. Tasks

Produces:

- `*.tasks.md`
- `*.task.md`

This step appears when `Plan` exists. `Tasks` decompose the work into concrete execution for agents or humans.

`Tasks` organizes work into functionally verifiable vertical phases. Each phase contains small contractual tasks.

The `*.tasks.md` index defines phases, order, explicit parallelization, and coverage. Each `*.task.md` contains the actionable contract for a specific task and can expand the rules referenced by the `Plan`.

This is where rules have their strongest operational effect: task files expand the relevant rule content so implementation can proceed from compact self-contained contracts. If the `Plan` intentionally has no rules, tasks may use `None.`, but that absence should be treated as an explicit limitation of the task contracts.

### 5. Implementation

Produces:

- the implemented code change,
- the real information needed to close the `Spec`.

### 6. Updated Spec

Produces:

- the final version of `*.spec.md`

The `Spec` is updated to reflect the real result and become the immediate basis for consolidation.

### 7. Updated Functional Truth

Produces:

- updated `functional.index.md` if needed,
- updated affected `*.entry.md` files,
- updated affected `*.global.entry.md` files.

The final result is a living functional truth aligned with what was implemented.

## 6. Operational rules

- Every change in the flow produces a `Spec`.
- `Plan` appears when the technical solution must be detailed.
- `Plan` can reference the project's persistent technical rules.
- `Tasks` appear when `Plan` exists.
- `Tasks` always live in their own document family.
- `Tasks` can expand rules to produce self-sufficient execution contracts.
- The `Spec` is updated at the end with the real result.
- The living functional truth is consolidated from that final `Spec`.

## 7. Closing the change

Closing the flow consists of:

1. updating the `Spec` with the actual implemented result,
2. consolidating that result into `functional.index.md`, `*.entry.md`, and `*.global.entry.md`,
3. removing the temporary documents for the change.

When finished, the living functional truth captures the current state of the product and again becomes the persistent reference for future changes.

## 8. Operational summary

- The project starts by creating `functional.index.md` and the necessary functional documents.
- The project should normally initialize reusable persistent technical rules after startup, while still allowing the user to skip them explicitly.
- Each change is evaluated with the question: `Does this change modify existing functional truth or add new functional truth?`.
- If the answer is yes, the minimum is a `Spec`.
- If the change requires more decomposition, `Plan` and `Tasks` are added.
- `Plan` can reference the project's persistent rules.
- `Tasks` can expand those rules for implementation.
- The `Spec` is updated with the real result.
- The living functional truth is consolidated.
- The temporary documents for the change are removed.

That is RedlineSpec's current main flow in its minimum and operational form.
