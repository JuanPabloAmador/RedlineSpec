# RedlineSpec

RedlineSpec is a contract-first specification-driven development framework for AI coding workflows.

It organizes product change around a living functional truth, temporary change contracts, persistent project rules, and workflow skills that guide agents through each phase.

## Status

Current version: `0.1.0`

This release provides the first usable framework surface, but it is still early. Harness-specific integrations for tools such as Codex, Claude Code, and opencode are intentionally outside this version.

## Core Model

RedlineSpec separates persistent project truth from temporary change contracts:

- `.redline/project/functional-truth/` stores the living functional truth.
- `.redline/project/rules/` stores persistent technical rules.
- `.redline/project/specs/` stores temporary contracts for active changes.
- `.redline/system/templates/` stores framework-distributed templates.
- `.redline/system/skills/` stores framework-distributed workflows.

The functional truth acts like `main` in Git. A `Spec` acts like a functional branch. When implementation is complete, the spec is closed and then merged back into the living functional truth.

## Workflow Surface

The distributed skills cover the current RedlineSpec lifecycle:

- `/bootstrap-functional-truth` creates or refines the initial functional baseline after installation.
- `/interview` gathers context before writing contracts.
- `/write-spec` writes functional change specs.
- `/write-plan` writes technical implementation plans.
- `/write-rules` creates or updates persistent project rules.
- `/write-tasks` decomposes a ready plan into executable task contracts.
- `/implement` executes approved task contracts without updating final truth.
- `/close-spec` verifies implementation evidence and aligns the final spec.
- `/merge-functional-truth` consolidates implemented specs into living functional truth.

## Installation

Run the installer from this repository and pass the target project explicitly:

```bash
bash scripts/install.sh TARGET_PATH
```

To refresh distributed framework assets in an already installed project:

```bash
bash scripts/install.sh TARGET_PATH --update-system
```

The installer creates the canonical `.redline/` layout, copies templates and skills into `.redline/system/`, initializes `functional.index.md` and `rules.index.md` when missing, and does not create fake change artifacts.

## Documentation

Start with:

- `docs/en/foundations.md`
- `docs/en/documents.md`
- `docs/en/main-flow.md`
- `docs/en/commands.md`
- `docs/en/installation.md`

## Versioning

RedlineSpec uses SemVer.

Version `0.1.0` is the first functional framework release. Breaking changes may still happen while the framework remains below `1.0.0`.
