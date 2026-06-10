# Harness Installation: Agent Skills

This document defines RedlineSpec harness bindings for concrete AI agents.

The canonical RedlineSpec runtime surface is **Agent Skills**. Harness-specific slash commands, workflow files, and other launcher formats are not installed or treated as canonical RedlineSpec assets.

Supported harness bindings:

- shared `.agents/skills/` group: `devin`, `codex`, `opencode`, `pi`
- private skill paths: `claude`

## Goal

RedlineSpec installs project state and framework templates under `.redline/`:

- `.redline/system/templates/`
- `.redline/system/scripts/`
- `.redline/project/functional-truth/`
- `.redline/project/rules/`
- `.redline/project/specs/`

The canonical skill source is the RedlineSpec distribution itself, not the target repository:

- `skills/`
- `redline-skills/`

Harness installation copies those skills into the effective skill directory where a concrete agent can discover and invoke them.

## Harness skill locations

### Shared `.agents` group

Harnesses compatible with the shared Agent Skills convention install one copy under:

- `.agents/skills/<name>/SKILL.md`

Current harnesses in this group:

- `devin`
- `codex`
- `opencode`
- `pi`

Selecting multiple harnesses in this group does not duplicate files. Devin does not use `.devin/skills/` as its primary RedlineSpec path.

### Private-path harnesses

Claude installs skills under:

- `.claude/skills/<name>/SKILL.md`

This path is installed only when `claude` is selected. Selecting `claude` alone does not create `.agents/skills/`.

## Compatibility conclusion

The RedlineSpec `SKILL.md` files are portable Agent Skills because they use:

- one folder per skill,
- `SKILL.md`,
- YAML frontmatter with only `name` and `description`,
- names that do not begin with `/`,
- descriptions suitable for automatic activation.

No command-wrapper conversion is required for supported harnesses.

## Installation model

Use a manifest-driven adapter model. Each harness declares:

- `HARNESS_ID`
- `HARNESS_SKILLS_GROUP` when it belongs to a shared destination group
- `HARNESS_SKILLS_PATH` for the effective skill destination

Examples:

```bash
HARNESS_ID="devin"
HARNESS_SKILLS_GROUP="agents"
HARNESS_SKILLS_PATH=".agents/skills"
```

```bash
HARNESS_ID="claude"
HARNESS_SKILLS_GROUP=""
HARNESS_SKILLS_PATH=".claude/skills"
```

Current manifests:

```txt
harnesses/devin/manifest.sh
harnesses/codex/manifest.sh
harnesses/claude/manifest.sh
harnesses/opencode/manifest.sh
harnesses/pi/manifest.sh
```

The installer reads the manifests, validates `HARNESS_ID`, resolves effective skill destinations, deduplicates destinations, and copies all RedlineSpec skills into each destination once.

Examples:

```txt
--harness devin
=> .agents/skills/

--harness devin,codex
=> .agents/skills/ only once

--harness devin,opencode
=> .agents/skills/ only once

--harness opencode,pi
=> .agents/skills/ only once

--harness claude
=> .claude/skills/
=> no .agents/skills/
```

## Update behavior

`--update-system` refreshes framework-managed system assets:

- `.redline/system/templates/`
- `.redline/system/scripts/`

`--update-harness` refreshes framework-managed skills in selected or detected effective skill destinations.

`--update` combines system and harness refresh.

Harness refresh removes known deprecated RedlineSpec skills, such as `redlinespec-spec-authoring`. During the temporary cleanup window recorded in `docs/en/deprecations.md`, it also removes old RedlineSpec-managed OpenCode launcher files from previous installations. It does not delete unrelated user-defined skills or unrelated harness files.

## Health check expectations

The deterministic health check verifies:

- required `.redline/` directories,
- required system templates,
- installed deterministic system scripts,
- required project indexes,
- RedlineSpec skills in detected `.agents/skills/` and `.claude/skills/` directories,
- valid skill frontmatter,
- frontmatter `name` matching the skill folder,
- deprecated skill folders.

It does not require OpenCode command launchers, Devin launchers, or Windsurf/Cascade workflow launchers. During the temporary cleanup window recorded in `docs/en/deprecations.md`, if old RedlineSpec-managed OpenCode launchers are still present, it reports them as deprecated.

## Non-goals

RedlineSpec harness installation does not:

- install slash-command wrappers,
- install Devin command or launcher files,
- install OpenCode command wrappers,
- install Windsurf/Cascade workflow launchers,
- configure global skill paths,
- modify harness-specific rules files,
- or make slash commands the identity of RedlineSpec workflows.
