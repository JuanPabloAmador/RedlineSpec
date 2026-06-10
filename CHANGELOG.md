# Changelog

All notable changes to RedlineSpec are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.0] - 2026-06-10

### Added

- Added `docs/en/skills.md` as the canonical Agent Skills catalog, replacing the former command-oriented catalog.
- Added `docs/en/deprecations.md` to track temporary migration cleanup windows and future removal targets.
- Added deterministic Bash validation for installed RedlineSpec skill frontmatter in `scripts/health-check.sh`.
- Added health-check validation that each skill frontmatter `name` matches the parent skill folder name.
- Added shared `.agents/skills/` harness group support with `devin`, `codex`, `opencode`, and `pi` manifests.

### Changed

- Normalized RedlineSpec skills as portable Agent Skills with `name` and `description` frontmatter only, without slash-command identity or harness launcher framing.
- Converted all skill descriptions to YAML-safe `description: >-` block scalars and removed YAML-hostile `aliases:` wording.
- Updated installer, health check, harness manifests, and documentation so harness bindings install skills only.
- Updated harness manifests and installer resolution so shared `.agents/skills/` destinations are installed once and the only private harness path remains separate: Claude under `.claude/skills/`.
- Changed Devin, OpenCode, and Pi primary RedlineSpec skill destinations to shared `.agents/skills/`.
- Updated health checks to validate `.agents/skills/`, the private Claude harness skill path `.claude/skills/`, deprecated skills, and legacy Devin/OpenCode/Pi-specific skill path migration.
- Dropped Windsurf as an installable harness; existing user `.windsurf/` files are not cleaned up.
- Updated Pi development settings to keep loading only installed/source-enabled skills from `skills/`, not in-progress workflow skill sources from `redline-skills/`.
- Updated user-facing documentation to describe Agent Skills as the canonical runtime surface.

### Removed

- Removed the legacy `redlinespec-spec-authoring` skill from distribution, installer requirements, health checks, and documented harness layouts. Installer harness refresh now removes this deprecated skill from selected or detected harness skill directories.
- Removed OpenCode command launchers and Windsurf workflow launchers from current harness installation assets.

## [0.3.0] - 2026-06-09

### Added

- Minimal `redlinespec` orientation skill for understanding the framework and choosing the next workflow.
- `health-check` workflow skill for deterministic installation checks, semantic documentation review, and standardized repair reports.
- `scripts/health-check.sh` for deterministic RedlineSpec installation and documentation structure checks, installed into `.redline/system/scripts/health-check.sh`.
- `scripts/install-remote.sh` for GitHub-based `curl | bash` installation without a local RedlineSpec clone.
- Pi harness support, installing RedlineSpec skills into `.pi/skills/` for Pi's native skill discovery.

### Changed

- Harness manifests may omit launcher paths for harnesses that invoke skills directly.

## [0.2.0] - 2026-06-03

### Added

- `plan-technical-unit.template.md` template for detailed technical unit contracts linked from plan indexes.

### Changed

- Reduced task index traceability noise by keeping task indexes focused on execution structure and moving task-level source traceability to individual task contracts.
- Renamed the internal interview skill from `interview-first` to `interview` across installer docs, harness bindings, and skill directory.
- Split plans into a compact plan index plus linked technical unit contract files for better progressive disclosure.

## [0.1.4] - 2026-05-28

### Changed

- Tightened `write-rules` so project rules are classified as persistent implementation constraints rather than general project decisions.

## [0.1.3] - 2026-05-27

### Changed

- Documented `write-rules` as the recommended post-bootstrap workflow for initializing persistent project technical rules.
- Updated the main flow to clarify that rules are optional but should normally be initialized before the first planned implementation flow.
- Updated `bootstrap-functional-truth` to recommend `write-rules` when no project rules exist yet.
- Updated `write-plan` to warn and ask before continuing when no active project rules are defined.
- Updated `write-tasks` to make rule-less task generation an explicit limitation rather than a silent default.

## [0.1.2] - 2026-05-27

### Fixed

- Installer harness selection is compatible with macOS Bash 3.2 by avoiding empty arrays under `set -u`.

## [0.1.1] - 2026-05-27

### Added

- Harness-native installation bindings for OpenCode and Windsurf.
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
- Harness refresh preserves unrelated user-defined skills.

## [0.1.0] - 2026-05-26

### Added

- Initial RedlineSpec document model for persistent functional truth, persistent project rules, and temporary change contracts.
- Canonical `.redline/` project layout with `system` and `project` separation.
- Bash installer for copying framework templates and skills into target projects.
- Templates for specs, plans, task indexes, task contracts, rules, rules index, functional truth index, functional entries, and global functional entries.
- Workflow skills for interviewing, writing specs, writing plans, writing rules, writing tasks, implementing tasks, bootstrapping functional truth, closing specs, and merging functional truth.
- English documentation for foundations, document catalog, main flow, skills catalog, and installation.

### Known Gaps

- Harness-specific integrations for Codex, Claude Code, opencode, and other agents are not included yet.
- The framework is pre-`1.0.0`; contract shapes and workflows may still evolve.
