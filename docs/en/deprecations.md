# RedlineSpec Deprecation Ledger

This document records temporary compatibility, cleanup, and migration behavior that should not live forever in the framework.

RedlineSpec assumes users update progressively from one released version to the next. Temporary migration code should cover a bounded upgrade window, then be removed once the expected adjacent-version migration path no longer needs it.

## Policy

For each deprecated artifact or behavior, record:

- what changed,
- why it changed,
- what temporary compatibility or cleanup exists,
- when it can be removed,
- and which files must be updated when it is removed.

Do not keep historical cleanup checks indefinitely. Once the removal target is reached, delete the cleanup logic and update the health check so it validates only the current framework contract.

## Active deprecations

### Legacy OpenCode command launchers

Status: active cleanup window.

Changed in: `0.4.0`.

Previous behavior:

- OpenCode harness installs included RedlineSpec command launcher files under `.opencode/commands/`.
- Those files framed RedlineSpec workflows as slash-command-like launchers.

Current behavior:

- RedlineSpec installs portable Agent Skills only.
- Harness manifests define only native skill paths.
- The canonical runtime surface is the installed `SKILL.md` folders.
- OpenCode command launchers are no longer distributed.

Reason:

- RedlineSpec skills are now normalized as portable Agent Skills.
- Slash-command and command-launcher framing should not be the framework identity.

Temporary migration behavior:

- `scripts/install.sh` removes old RedlineSpec-managed OpenCode launchers from `.opencode/commands/<skill>.md`.
- `scripts/health-check.sh` reports old RedlineSpec-managed OpenCode launchers as deprecated when found.
- Unrelated user-defined command files are preserved.

Removal target:

- Remove this temporary cleanup after the next stable release cycle that follows the Agent Skills-only release.
- Suggested target: remove no later than `0.5.0`, unless a `1.0.0` stabilization happens first.

Files to update when removing this cleanup:

- `scripts/install.sh`
  - remove `remove_deprecated_launchers_for_harness` and its call.
- `scripts/health-check.sh`
  - remove warnings for `.opencode/commands/<skill>.md`.
- `docs/en/harness-installation.md`
  - remove mention that old RedlineSpec-managed OpenCode launchers are cleaned up or reported.
- `docs/en/installation.md`
  - remove mention that harness refresh removes old RedlineSpec launcher files.
- `CHANGELOG.md`
  - record the final removal in the release where cleanup support is dropped.

Do not remove:

- general support for installing Agent Skills into `.agents/skills/` or `.claude/skills/`.
- deprecation notes for older Devin, OpenCode, or Pi installations that used harness-specific skill paths.
- historical changelog entries that describe what older releases shipped.

## Dropped harness support

### Windsurf harness bindings

Status: support dropped; no user cleanup.

Changed in: `0.4.0`.

Previous behavior:

- RedlineSpec distributed a Windsurf harness manifest and installed skills under `.windsurf/skills/`.
- Older releases also distributed Windsurf workflow launcher files under `.windsurf/workflows/`.

Current behavior:

- RedlineSpec no longer supports Windsurf as an installable harness.
- The installer no longer accepts `--harness windsurf`.
- The health check no longer validates `.windsurf/skills/` or `.windsurf/workflows/`.
- Existing user `.windsurf/` files are not cleaned up by RedlineSpec.

Reason:

- RedlineSpec is standardizing around portable Agent Skills for currently supported harnesses.
- Current supported harness bindings are the shared `.agents/skills/` group (`devin`, `codex`, `opencode`, `pi`) plus Claude private path.
