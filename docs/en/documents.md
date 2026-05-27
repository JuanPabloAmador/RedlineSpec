# RedlineSpec Documents

RedlineSpec organizes work around persistent project documents and temporary change contracts.

This document defines the framework's official catalog of textual documents and their canonical location inside `.redline/`.

## 1. General principle

RedlineSpec distinguishes between two spaces inside `.redline/`:

- `system`: distributed framework internals.
- `project`: real project documents.

The canonical root is:

```txt
.redline/
```

Inside it:

```txt
.redline/
  system/
    templates/
    skills/
  project/
    functional-truth/
    rules/
    specs/
```

The project's official documents live under `.redline/project/`.

The files in `.redline/system/` belong to the framework itself: distributed templates and skills. They are required to operate RedlineSpec, but they are not part of the functional truth or the change contracts of a specific project.

## 2. Flow activation rule

The operational question that decides whether a change enters the RedlineSpec flow is:

> Does this change modify existing functional truth or add new functional truth?

If the answer is no, the change can be handled outside the RedlineSpec flow.

If the answer is yes, the change enters the flow and the minimum required document is a `Spec`.

## 3. Persistent project documents

Persistent project documents are divided into two families:

- functional truth,
- persistent implementation rules.

Rules are not part of the functional truth, but they are part of the project's official and persistent catalog.

### 3.1 Persistent functional truth

The functional truth lives in:

```txt
.redline/project/functional-truth/
```

#### 3.1.1 `functional.index.md`

Canonical path:

- `.redline/project/functional-truth/functional.index.md`

It is the root document of the functional truth.

Its function is to:

- route to the rest of the functional documents,
- provide a global view of the system,
- indicate coverage and status,
- contain or reference cross-cutting truth,
- favor progressive disclosure.

`functional.index.md` must not absorb the entire project's functional truth. It should remain small and act as an entry and navigation point.

#### 3.1.2 `*.entry.md`

They live in:

- `.redline/project/functional-truth/`

Examples:

- `.redline/project/functional-truth/profile.entry.md`
- `.redline/project/functional-truth/checkout.entry.md`

Their function is to describe a unit of functional truth.

#### 3.1.3 `*.global.entry.md`

They live in:

- `.redline/project/functional-truth/`

Example:

- `.redline/project/functional-truth/permissions.global.entry.md`

Their function is to capture project-wide cross-cutting functional truth when it is useful to separate it into dedicated files.

### 3.2 Persistent project rules

Rules live in:

```txt
.redline/project/rules/
```

The folder is physically flat to favor simple navigation by agents and scripts.

#### 3.2.1 `rules.index.md`

Canonical path:

- `.redline/project/rules/rules.index.md`

Its function is to:

- list all project rules,
- group them logically by `domain` and then by `type`,
- serve as a lightweight entry point to the rules system,
- and favor progressive disclosure toward specific `*.rule.md` files.

#### 3.2.2 `*.rule.md`

They live in:

- `.redline/project/rules/`

Examples:

- `.redline/project/rules/ui-angular-onpush.rule.md`
- `.redline/project/rules/server-error-shape.rule.md`

Structural rules:

- each file uses naming with a `domain` prefix,
- each rule is small, atomic, and reusable,
- each rule has frontmatter with `id`, `title`, `domain`, `type`,
- the body is free-form Markdown,
- and a rule must not become a temporary document for a specific change.

Their function is to capture persistent implementation constraints that future agents must apply while changing, verifying, or approving code so they can be referenced by `Plan` and later expanded in `Tasks`.

Rules are not every persistent project decision. Stack choices, tool settings, release procedures, general documentation, functional truth, and collaboration preferences should stay in their proper documents unless they need a separate implementation or verification constraint that agents must follow while editing code.

## 4. Temporary change documents

Temporary documents live under:

```txt
.redline/project/specs/
```

Each change in the flow has its own folder:

```txt
.redline/project/specs/<change>/
```

The temporary contracts for that change live inside that folder.

### 4.1 `Spec`

Canonical path:

- `.redline/project/specs/<change>/<change>.spec.md`

It is the minimum required document in the flow.

Its function is to:

- represent the functional branch of the change,
- describe the delta against the current functional truth,
- guide direct implementation when the change is small,
- serve as the basis for `Plan` if technical breakdown is needed,
- and serve as the basis for consolidation at the end.

The `Spec` starts as a change proposal, but at the end it must be updated to reflect the actual implemented result.

### 4.2 `Plan`

Canonical path:

- `.redline/project/specs/<change>/plan/<change>.plan.md`

It is an optional document in the flow, used when technical complexity requires an explicit technical contract.

Its function is to translate the `Spec` into a technical form executable by humans or agents:

- technical blocks,
- technical units,
- signatures,
- shapes,
- dependencies,
- artifacts,
- affected areas,
- applicable rules,
- and supporting technical context when needed.

The `Plan` defines the technical how. It does not define an execution timeline; that dimension belongs to `Tasks`.

### 4.3 `Tasks`

They live in:

- `.redline/project/specs/<change>/tasks/`

`Tasks` only exist when `Plan` exists.

Their function is to decompose execution into actionable contracts.

The detailed organization of `Tasks` uses progressive disclosure:

- `.redline/project/specs/<change>/tasks/<change>.tasks.md`
- `.redline/project/specs/<change>/tasks/phase-01-task-01-<slug>.task.md`

The `*.tasks.md` index organizes vertical phases, execution order, explicit parallelization, and coverage.

Each `*.task.md` is a compact, actionable contract for a specific task.

Phases are functionally verifiable vertical slices. Tasks are small steps inside those phases.

Task files are where rule references from the `Plan` can be expanded to make each task self-sufficient.

## 5. Relationships between documents

The minimum flow rules are:

- If a change enters the flow, a `Spec` always exists.
- A `Plan` only exists if the change has enough technical complexity.
- If `Plan` exists, then `Tasks` exist.
- There can be no `Tasks` without `Plan`.
- The `Spec` is updated at the end with the actual implemented result.
- Project rules are persistent and can be referenced by `Plan`.
- `Tasks` can expand those rules to produce self-sufficient execution contracts.

This produces three operational levels:

- change outside the flow,
- simple flow change: `Spec`,
- complex flow change: `Spec -> Plan -> Tasks`.

## 6. Progressive disclosure

RedlineSpec's document organization must favor progressive disclosure.

This means:

- keeping the functional truth divided into small or medium-sized pieces,
- using `functional.index.md` as the entry point,
- keeping rules in small and atomic files,
- using `rules.index.md` as a lightweight index,
- grouping each temporary change in its own folder under `specs/`,
- allowing `Plan` to link supporting context without absorbing it,
- and allowing `Tasks` to use their own files when a task needs more context.

## 7. What RedlineSpec does not consider official project documents

The following artifacts may exist as working material, but they are not part of the project's official catalog:

- discovery notes,
- analysis notes,
- baseline exploration,
- unconsolidated intermediate notes,
- separate `Implementation Report`,
- separate `Functional Merge` document.

## 8. Lifecycle

These persist over time:

- `.redline/project/functional-truth/`
- `.redline/project/rules/`

These are ephemeral and must be removed after consolidation:

- `.redline/project/specs/<change>/...`

Once the change is consolidated into the living functional truth, that change's temporary folder must be removed from the operational repository.

The goal is to prevent future agents from being contaminated by historical contracts that no longer represent the product's current state.

## 9. Canonical layout summary

```txt
.redline/
  system/
    templates/
    skills/
  project/
    functional-truth/
      functional.index.md
      *.entry.md
      *.global.entry.md
    rules/
      rules.index.md
      *.rule.md
    specs/
      <change>/
        <change>.spec.md
        plan/
          <change>.plan.md
        tasks/
          <change>.tasks.md
          phase-01-task-01-<slug>.task.md
```

This is RedlineSpec's current official catalog of textual documents and its canonical layout inside `.redline/`.
