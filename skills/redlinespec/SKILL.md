---
name: redlinespec
description: Minimal orientation to RedlineSpec. Use to understand what RedlineSpec is, when to activate its workflows, and where to go next.
---

# RedlineSpec

RedlineSpec is a contract-first framework for AI coding workflows. It keeps product change aligned through:

- **Functional truth**: persistent description of what the product currently does.
- **Specs**: temporary contracts for functional changes.
- **Rules**: persistent implementation constraints.
- **Workflow skills**: focused procedures for each phase.

## Mental Model

RedlineSpec uses a Git-like analogy:

- The **living functional truth** acts like `main`. It describes what the product currently does from a product perspective.
- A **Spec** acts like a branch. It defines a functional change as a delta from the current truth.
- When implementation is complete, the Spec is **closed** (updated with real results) and then **merged** back into the functional truth.
- Temporary change documents are **removed** after merge to prevent stale contracts from competing with current truth.

## Activation Rule

Ask:

> Does this change modify existing functional truth or add new functional truth?

- **No**: handle the request directly.
- **Yes**: enter the RedlineSpec flow.

## Workflow Map

### First-time setup

```txt
/bootstrap-functional-truth → /write-rules (optional)
```

### Change flow

```txt
/interview → /write-spec → /implement → /close-spec → /merge-functional-truth
```

Use the extended flow when the change needs technical decomposition:

```txt
/interview → /write-spec → /write-plan → /write-tasks → /implement → /close-spec → /merge-functional-truth
```

## Documents

All RedlineSpec documents live under `.redline/`:

- `.redline/project/functional-truth/` — persistent product truth.
- `.redline/project/rules/` — persistent implementation rules.
- `.redline/project/specs/` — temporary specs, plans, and tasks.
- `.redline/system/templates/` — document templates.

## Guidance

- Load this skill only for orientation.
- Once the next workflow is known, activate and follow that workflow skill.
- Read templates before creating or updating RedlineSpec documents.
- Keep temporary specs, plans, and tasks out of the functional truth after merge.
