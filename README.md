# RedlineSpec

RedlineSpec is a contract-first specification-driven development framework for AI coding workflows.

It organizes product change around a living functional truth, temporary change contracts, persistent project rules, and workflow skills that guide agents through each phase.

## Status

Current version: `0.3.0`

This release adds remote installation, Pi harness support, framework orientation, and health-check workflows. The framework is still early and may change before `1.0.0`.

## Core Model

RedlineSpec separates persistent project truth from temporary change contracts:

- `.redline/project/functional-truth/` stores the living functional truth.
- `.redline/project/rules/` stores persistent implementation rules.
- `.redline/project/specs/` stores temporary contracts for active changes.
- `.redline/system/templates/` stores framework-distributed templates.
- `.redline/system/scripts/` stores deterministic framework scripts such as `health-check.sh`.

Workflow skills are canonical in the RedlineSpec distribution and are copied into harness-native skill folders when a harness is installed.

The functional truth acts like `main` in Git. A `Spec` acts like a functional branch. When implementation is complete, the spec is closed and then merged back into the living functional truth.

## Workflow Surface

The distributed skills cover the current RedlineSpec lifecycle:

- `/redlinespec` orients the agent and routes to the next workflow.
- `/health-check` verifies installation and documentation health and produces a repair report.
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

Install directly from GitHub into the current project:

```bash
curl -fsSL https://raw.githubusercontent.com/JuanPabloAmador/RedlineSpec/main/scripts/install-remote.sh | bash -s -- --harness pi
```

Or install into an explicit target path:

```bash
curl -fsSL https://raw.githubusercontent.com/JuanPabloAmador/RedlineSpec/main/scripts/install-remote.sh | bash -s -- TARGET_PATH --harness opencode
```

To install from a local clone instead, run the installer from this repository and pass the target project explicitly:

```bash
bash scripts/install.sh TARGET_PATH
```

When run in an interactive terminal, the local installer prompts you to choose the harness bindings to install. In non-interactive shells, pass the harness explicitly:

```bash
bash scripts/install.sh TARGET_PATH --harness opencode
bash scripts/install.sh TARGET_PATH --harness windsurf
bash scripts/install.sh TARGET_PATH --harness pi
bash scripts/install.sh TARGET_PATH --harness opencode --harness windsurf
bash scripts/install.sh TARGET_PATH --harness opencode,windsurf,pi
```

To refresh an already installed project, including templates and all detected harness bindings:

```bash
bash scripts/install.sh TARGET_PATH --update
```

To refresh only one specific harness binding:

```bash
bash scripts/install.sh TARGET_PATH --harness opencode --update-harness
```

The installer creates the canonical `.redline/` project layout, copies templates into `.redline/system/templates/`, copies deterministic scripts into `.redline/system/scripts/`, initializes `functional.index.md` and `rules.index.md` when missing, and does not create fake change artifacts. Skills are installed into harness-visible folders for the selected harnesses.

## Documentation

Start with:

- `docs/en/foundations.md`
- `docs/en/documents.md`
- `docs/en/main-flow.md`
- `docs/en/commands.md`
- `docs/en/installation.md`
- `docs/en/harness-installation.md`

## Versioning

RedlineSpec uses SemVer.

Version `0.3.0` adds GitHub-based remote installation, Pi harness support, `/redlinespec` orientation, and `/health-check` validation. Breaking changes may still happen while the framework remains below `1.0.0`.
