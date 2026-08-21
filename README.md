# RedlineSpec

RedlineSpec is a contract-first specification-driven development framework for AI coding workflows.

It organizes product change around a living functional truth, temporary change contracts, persistent project rules, and workflow skills that guide agents through each phase.

## Official website

The official website is [redlinespec.com](https://redlinespec.com).

## Distribution

RedlineSpec is distributed **only** through this GitHub repository. There is no npm package, PyPI package, or distribution through any other registry, channel, or third-party site.

If you find RedlineSpec packaged somewhere else — a registry package, a CLI binary, a Docker image, or a download site — it is not official. Always install from this repository: <https://github.com/JuanPabloAmador/RedlineSpec>.

## Status

Current version: `0.5.2`

This release moves Plan TU granularity from per-file to per-module/capability: each TU is a cohesive module graph node that may own several tightly-coupled artifacts. File-level atomicity remains the responsibility of `write-tasks` task decomposition. The framework is still early and may change before `1.0.0`.

## Core Model

RedlineSpec separates persistent project truth from temporary change contracts:

- `.redline/project/functional-truth/` stores the living functional truth.
- `.redline/project/rules/` stores persistent implementation rules.
- `.redline/project/specs/` stores temporary contracts for active changes.
- `.redline/system/templates/` stores framework-distributed templates.
- `.redline/system/scripts/` stores deterministic framework scripts such as `health-check.sh`.

Workflow skills are canonical in the RedlineSpec distribution and are copied into effective harness-visible skill folders when a harness is installed. Harnesses compatible with the shared Agent Skills convention use one deduplicated `.agents/skills/` copy; harnesses with private paths use their own skill folders.

The functional truth acts like `main` in Git. A `Spec` acts like a functional branch. When implementation is complete, the spec is closed and then merged back into the living functional truth.

## Agent Skills Surface

The distributed Agent Skills cover the current RedlineSpec lifecycle:

- `redlinespec` orients the agent and routes to the next workflow.
- `health-check` verifies installation and documentation health and produces a repair report.
- `bootstrap-functional-truth` creates or refines the initial functional baseline after installation.
- `interview` gathers context before writing contracts.
- `write-spec` writes functional change specs.
- `write-plan` writes technical implementation plans.
- `write-rules` creates or updates persistent project rules.
- `write-tasks` decomposes a ready plan into executable task contracts.
- `implement` executes approved task contracts without updating final truth.
- `close-spec` verifies implementation evidence and aligns the final spec.
- `merge-functional-truth` consolidates implemented specs into living functional truth.

## Installation

There are two common operations:

1. **First install:** choose the harness or harnesses you want RedlineSpec to expose skills to.
2. **Update an existing install:** refresh RedlineSpec system templates, scripts, and every already installed harness binding.

### First install: choose a harness

Install directly from GitHub into the current project, choosing the concrete harness command:

| Harness | Command |
| --- | --- |
| Devin | `curl -fsSL https://raw.githubusercontent.com/JuanPabloAmador/RedlineSpec/main/scripts/install-remote.sh \| bash -s -- --harness devin` |
| Codex | `curl -fsSL https://raw.githubusercontent.com/JuanPabloAmador/RedlineSpec/main/scripts/install-remote.sh \| bash -s -- --harness codex` |
| OpenCode | `curl -fsSL https://raw.githubusercontent.com/JuanPabloAmador/RedlineSpec/main/scripts/install-remote.sh \| bash -s -- --harness opencode` |
| Pi | `curl -fsSL https://raw.githubusercontent.com/JuanPabloAmador/RedlineSpec/main/scripts/install-remote.sh \| bash -s -- --harness pi` |
| Claude | `curl -fsSL https://raw.githubusercontent.com/JuanPabloAmador/RedlineSpec/main/scripts/install-remote.sh \| bash -s -- --harness claude` |

The first install is non-destructive for existing framework files: it copies missing templates, scripts, project bootstrap files, and selected harness skills. It does not refresh already existing RedlineSpec files unless you use an update flag.

To install into an explicit target path, put the target path before the harness flag. Example:

```bash
curl -fsSL https://raw.githubusercontent.com/JuanPabloAmador/RedlineSpec/main/scripts/install-remote.sh | bash -s -- ~/work/my-project --harness opencode
```

To install from a local clone instead, run the installer from this repository and pass the target project explicitly:

```bash
bash scripts/install.sh TARGET_PATH
```

When run in an interactive terminal, the local installer prompts you to choose the harness bindings to install. In non-interactive shells, pass the harness explicitly:

```bash
bash scripts/install.sh TARGET_PATH --harness devin
bash scripts/install.sh TARGET_PATH --harness codex,devin
bash scripts/install.sh TARGET_PATH --harness opencode
bash scripts/install.sh TARGET_PATH --harness pi
bash scripts/install.sh TARGET_PATH --harness claude
bash scripts/install.sh TARGET_PATH --harness devin,opencode
bash scripts/install.sh TARGET_PATH --harness opencode,pi
```

### Update an existing install

For an already installed project, the usual command is `--update`. It refreshes `.redline/system/templates/`, `.redline/system/scripts/`, and all detected installed harness bindings:

```bash
curl -fsSL https://raw.githubusercontent.com/JuanPabloAmador/RedlineSpec/main/scripts/install-remote.sh | bash -s -- --update
```

From a local clone:

```bash
bash scripts/install.sh TARGET_PATH --update
```

If you want to refresh only one specific harness binding, use `--update-harness` with `--harness`:

```bash
curl -fsSL https://raw.githubusercontent.com/JuanPabloAmador/RedlineSpec/main/scripts/install-remote.sh | bash -s -- --harness opencode --update-harness
bash scripts/install.sh TARGET_PATH --harness opencode --update-harness
```

If you want to refresh only system templates and scripts, without touching harness skills:

```bash
curl -fsSL https://raw.githubusercontent.com/JuanPabloAmador/RedlineSpec/main/scripts/install-remote.sh | bash -s -- --update-system
bash scripts/install.sh TARGET_PATH --update-system
```

The installer creates the canonical `.redline/` project layout, copies templates into `.redline/system/templates/`, copies deterministic scripts into `.redline/system/scripts/`, initializes `functional.index.md` and `rules.index.md` when missing, and does not create fake change artifacts. Skills are installed into effective harness-visible folders for the selected harnesses: shared `.agents/skills/` once for `devin`, `codex`, `opencode`, and `pi`, plus Claude’s private path `.claude/skills/` when selected.

## Documentation

Start with:

- `docs/en/foundations.md`
- `docs/en/documents.md`
- `docs/en/main-flow.md`
- `docs/en/skills.md`
- `docs/en/installation.md`
- `docs/en/harness-installation.md`
- `docs/en/deprecations.md`

## Versioning

RedlineSpec uses SemVer.

Version `0.5.2` moves Plan TU granularity from per-file to per-module/capability: each TU is a cohesive module graph node and the module dependency graph is explicit in `Dependencies`. Version `0.5.1` added deterministic health-check validation for the `Execution Tree` task model, and version `0.5.0` replaced the sequential order plus `parallel_group` execution model with per-phase `Execution Tree`s: task indexes define order and unlocking, sibling groups marked `[∥]` are parallelizable, and `implement` dispatches them to one subagent per task when the harness supports it. `write-tasks` now forces a granularity review so every task covers exactly one unit of work. Breaking changes may still happen while the framework remains below `1.0.0`.
