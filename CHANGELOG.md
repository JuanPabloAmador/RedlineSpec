# Changelog

All notable changes to RedlineSpec are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Nothing yet.

## [0.1.4] - 2026-05-28

### Changed

- Tightened `/write-rules` so project rules are classified as persistent implementation constraints rather than general project decisions.

## [0.1.3] - 2026-05-27

### Changed

- Documented `/write-rules` as the recommended post-bootstrap workflow for initializing persistent project technical rules.
- Updated the main flow to clarify that rules are optional but should normally be initialized before the first planned implementation flow.
- Updated `/bootstrap-functional-truth` to recommend `/write-rules` when no project rules exist yet.
- Updated `/write-plan` to warn and ask before continuing when no active project rules are defined.
- Updated `/write-tasks` to make rule-less task generation an explicit limitation rather than a silent default.

## [0.1.2] - 2026-05-27

### Fixed

- Installer harness selection is compatible with macOS Bash 3.2 by avoiding empty arrays under `set -u`.

## [0.1.1] - 2026-05-27

### Added

- Harness-native installation bindings for OpenCode and Windsurf.
- OpenCode command launchers under `.opencode/commands/`.
- Windsurf workflow launchers under `.windsurf/workflows/`.
- Harness adapter manifests for scalable future harness support.
- Installer support for repeated and comma-separated `--harness` selections.
- Interactive harness selection for terminal installs.
- `--update` mode to refresh templates and all detected installed harness bindings.

### Changed

- Skills are now installed only into harness-visible skill folders such as `.opencode/skills/` and `.windsurf/skills/`.
- `.redline/system/skills/` is no longer installed by default; the RedlineSpec distribution remains the canonical skill source.
- `--update-system` now refreshes framework templates only.

### Fixed

- Installer failures before harness resolution no longer leave partial `.redline/` directories behind.
- `--update` detects installed harnesses without installing missing harnesses.
- Harness refresh preserves unrelated user-defined skills, commands, and workflows.

## [0.1.0] - 2026-05-26

### Added

- Initial RedlineSpec document model for persistent functional truth, persistent project rules, and temporary change contracts.
- Canonical `.redline/` project layout with `system` and `project` separation.
- Bash installer for copying framework templates and skills into target projects.
- Templates for specs, plans, task indexes, task contracts, rules, rules index, functional truth index, functional entries, and global functional entries.
- Workflow skills for interviewing, writing specs, writing plans, writing rules, writing tasks, implementing tasks, bootstrapping functional truth, closing specs, and merging functional truth.
- English documentation for foundations, document catalog, main flow, commands, and installation.

### Known Gaps

- Harness-specific integrations for Codex, Claude Code, opencode, and other agents are not included yet.
- The framework is pre-`1.0.0`; contract shapes and workflows may still evolve.
