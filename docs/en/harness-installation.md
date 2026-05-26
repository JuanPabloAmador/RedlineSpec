# Harness Installation: OpenCode and Windsurf

This document defines the next RedlineSpec installation step: optional harness bindings for concrete AI agents.

The first supported harnesses should be:

- `opencode`
- `windsurf`

## Goal

RedlineSpec installs project state and framework templates under `.redline/`:

- `.redline/system/templates/`
- `.redline/project/functional-truth/`
- `.redline/project/rules/`
- `.redline/project/specs/`

The canonical skill source is the RedlineSpec distribution itself, not the target repository.

Harness installation adds the native files needed for a concrete agent to discover and invoke RedlineSpec skills.

## Documentation Findings

### OpenCode

OpenCode supports agent skills as folders named after the skill, each containing `SKILL.md`.

Recognized project-local skill locations include:

- `.opencode/skills/<name>/SKILL.md`
- `.agents/skills/<name>/SKILL.md`
- `.claude/skills/<name>/SKILL.md`

Recognized global skill locations include:

- `~/.config/opencode/skills/<name>/SKILL.md`
- `~/.agents/skills/<name>/SKILL.md`
- `~/.claude/skills/<name>/SKILL.md`

OpenCode also supports custom commands as markdown files:

- project: `.opencode/commands/<command>.md`
- global: `~/.config/opencode/commands/<command>.md`

Command files use YAML frontmatter for metadata such as `description`, `agent`, `model`, and `subtask`; the markdown body is the command prompt template.

OpenCode's config schema also supports additional skill folder paths through:

```json
{
  "skills": {
    "paths": ["./some/path"]
  }
}
```

RedlineSpec uses copied project-local skills under `.opencode/skills/` for OpenCode's native installation path.

### Windsurf

Windsurf Cascade supports skills as folders named after the skill, each containing `SKILL.md`.

Recognized project-local skill locations include:

- `.windsurf/skills/<name>/SKILL.md`
- `.agents/skills/<name>/SKILL.md`

Recognized global skill locations include:

- `~/.codeium/windsurf/skills/<name>/SKILL.md`
- `~/.agents/skills/<name>/SKILL.md`

Windsurf also scans `.claude/skills/` when Claude Code config reading is enabled, but that should not be the primary RedlineSpec path.

Windsurf supports workflows as slash-command markdown files:

- project: `.windsurf/workflows/<workflow>.md`
- global: `~/.codeium/windsurf/global_workflows/<workflow>.md`

Workflows are manual-only and invoked as `/<workflow>`. Skills may be invoked by model decision or manually via `@skill-name`.

Windsurf also supports rules in `.windsurf/rules/*.md`, but RedlineSpec workflow activation should not use rules. Rules are better for durable behavior constraints, not workflow commands.

## Compatibility Conclusion

The current RedlineSpec `SKILL.md` files are already compatible with both OpenCode and Windsurf at the skill format level because they use:

- one folder per skill,
- `SKILL.md`,
- YAML frontmatter,
- required `name`,
- required `description`.

No skill format conversion is needed for the first integration.

The installer does need harness-specific artifacts for command invocation:

- OpenCode command files under `.opencode/commands/`.
- Windsurf workflow files under `.windsurf/workflows/`.

## Installation Model

Use a manifest-driven adapter model instead of a single hardcoded layout.

There are three different artifact roles:

- RedlineSpec project state: durable framework documents and templates used by workflows.
- Harness-visible skills: `SKILL.md` folders installed where a concrete harness can discover and invoke them.
- Harness-visible launchers: slash commands, workflows, or equivalent files that expose `/write-spec`, `/implement`, and the rest of the RedlineSpec command surface.

The installer should not assume every harness can read the same directories or the same launcher format. Each harness adapter should declare its own native locations and artifact formats.

Default manual installation should prompt for a harness when no harness flag is provided:

```bash
bash scripts/install.sh TARGET_PATH
```

Scripted and non-interactive installation must pass a harness explicitly:

```bash
bash scripts/install.sh TARGET_PATH [--update] [--update-system] [--harness opencode[,windsurf]]... [--update-harness]
```

This avoids successful but unusable installations. A project must always receive at least one harness binding set.

## Canonical Runtime Assets

`.redline/system/skills/` is not part of the target runtime model.

Keeping a second skill copy there gives conceptual completeness, but it is not operationally useful once harness-visible skill installation exists.

No current supported harness invokes skills from `.redline/system/skills/` by default. If we copy skills there and also into `.opencode/skills/` or `.windsurf/skills/`, the target repository gets duplicate framework code and the copies can drift.

The target model is:

- keep `.redline/project/` as the durable project-owned RedlineSpec state,
- keep `.redline/system/templates/` because skills read templates from a stable framework path,
- keep the canonical skill source in the RedlineSpec distribution repository or package,
- install skills only into harness-visible locations selected by `--harness`.

If a future distribution mode needs a full self-contained framework bundle inside the target repository, it should be added as a separate explicit option. It should not be the default runtime install.

## Harness Adapter Shape

Each supported harness should have a small adapter manifest.

Conceptual shape:

```yaml
id: opencode
skills:
  format: agent-skills
  project_path: .opencode/skills
launchers:
  kind: commands
  project_path: .opencode/commands
  source_path: harnesses/opencode/commands
```

```yaml
id: windsurf
skills:
  format: agent-skills
  project_path: .windsurf/skills
launchers:
  kind: workflows
  project_path: .windsurf/workflows
  source_path: harnesses/windsurf/workflows
```

This model scales because adding a future harness becomes adding an adapter entry and artifact templates, not changing the core installer model.

## Skill Placement Options

There are two viable skill placement strategies.

### Native Strategy

Install skills in each harness's native project-local skill directory.

For OpenCode:

```txt
.opencode/
  skills/
    write-spec/
      SKILL.md
  commands/
    write-spec.md
```

For Windsurf:

```txt
.windsurf/
  skills/
    write-spec/
      SKILL.md
  workflows/
    write-spec.md
```

If both harnesses are installed, the same skill is copied to both native locations.

Pros:

- most explicit,
- easiest to reason about per harness,
- does not depend on cross-tool compatibility conventions,
- scales to harnesses that do not support `.agents/skills/`.

Cons:

- duplicates skill files when multiple harnesses are installed.

### Shared Agent-Skills Strategy

Install skills once in the shared `.agents/skills/` location, then install only harness launchers in native folders.

For OpenCode and Windsurf together:

```txt
.agents/
  skills/
    write-spec/
      SKILL.md
.opencode/
  commands/
    write-spec.md
.windsurf/
  workflows/
    write-spec.md
```

Pros:

- avoids skill duplication for harnesses that support `.agents/skills/`,
- works for the first two harnesses,
- keeps one harness-visible skill copy.

Cons:

- not guaranteed for every future harness,
- less native and therefore less obvious to users inspecting `.opencode/` or `.windsurf/`,
- requires the installer to know which harnesses support the shared convention.

Default for scale: use the native strategy first.

Optional optimization: support a later flag such as `--shared-skills agents` for harness combinations known to support `.agents/skills/`.

## Directory Clarification

The same artifact should not be installed into all three folders by default.

The folders have different roles:

- `.opencode/skills/`: OpenCode-native skill location.
- `.opencode/commands/`: OpenCode slash-command launchers.
- `.windsurf/skills/`: Windsurf-native skill location.
- `.windsurf/workflows/`: Windsurf slash-command workflow launchers.
- `.agents/skills/`: optional shared skill location supported by OpenCode and Windsurf, useful only when the installer intentionally chooses a shared strategy.

So the default native install is:

- `--harness opencode`: install skills in `.opencode/skills/` and commands in `.opencode/commands/`.
- `--harness windsurf`: install skills in `.windsurf/skills/` and workflows in `.windsurf/workflows/`.
- `--harness opencode --harness windsurf`: install both selected harnesses.
- `--harness opencode,windsurf`: equivalent comma-separated form.

An optional shared install would be:

- `--harness opencode,windsurf --shared-skills agents`: install skills once in `.agents/skills/`, plus OpenCode commands and Windsurf workflows.

## Recommended Command and Workflow Bindings

### OpenCode

Install command files to:

```txt
.opencode/
  skills/
    bootstrap-functional-truth/
    interview-first/
    write-spec/
    write-plan/
    write-rules/
    write-tasks/
    implement/
    close-spec/
    merge-functional-truth/
    redlinespec-spec-authoring/
  commands/
    bootstrap-functional-truth.md
    interview.md
    write-spec.md
    write-plan.md
    write-rules.md
    write-tasks.md
    implement.md
    close-spec.md
    merge-functional-truth.md
```

Each command should be a thin launcher that tells OpenCode to load or use the corresponding skill.

Example:

```markdown
---
description: Execute the RedlineSpec /write-spec workflow
---

Use the `write-spec` skill to execute the RedlineSpec `/write-spec` workflow.

User arguments:

$ARGUMENTS
```

Do not duplicate the full workflow instructions inside command files. The command should route to the skill so there is a single maintained workflow body.

### Windsurf

Install workflow files to:

```txt
.windsurf/
  skills/
    bootstrap-functional-truth/
    interview-first/
    write-spec/
    write-plan/
    write-rules/
    write-tasks/
    implement/
    close-spec/
    merge-functional-truth/
    redlinespec-spec-authoring/
  workflows/
    bootstrap-functional-truth.md
    interview.md
    write-spec.md
    write-plan.md
    write-rules.md
    write-tasks.md
    implement.md
    close-spec.md
    merge-functional-truth.md
```

Each workflow should be a thin launcher that mentions the corresponding skill.

Example:

```markdown
# RedlineSpec /write-spec

Use the `write-spec` skill to execute the RedlineSpec `/write-spec` workflow.

If Cascade does not automatically invoke the skill, explicitly load `@write-spec` and follow it.

User request or arguments follow from the slash-command invocation.
```

Do not duplicate the full workflow instructions inside workflow files.

## Source Tree Changes

Add harness artifact templates to the RedlineSpec repository instead of hardcoding command bodies in `install.sh`.

Recommended source layout:

```txt
harnesses/
  opencode/
    manifest.sh
    commands/
      bootstrap-functional-truth.md
      interview.md
      write-spec.md
      write-plan.md
      write-rules.md
      write-tasks.md
      implement.md
      close-spec.md
      merge-functional-truth.md
  windsurf/
    manifest.sh
    workflows/
      bootstrap-functional-truth.md
      interview.md
      write-spec.md
      write-plan.md
      write-rules.md
      write-tasks.md
      implement.md
      close-spec.md
      merge-functional-truth.md
```

The command and workflow files should be committed artifacts. The installer should copy them.

Avoid generated command text for now. Static files are easier to review and version.

The skill source should remain the existing framework skill directories in the RedlineSpec distribution:

```txt
skills/
redline-skills/
```

The installer copies those source skills into the harness adapter's selected skill path.

## Installer Changes

Extend `scripts/install.sh` with these concepts.

### New flags

```txt
--harness opencode       Install OpenCode bindings.
--harness windsurf       Install Windsurf bindings.
--harness opencode,windsurf
                         Install multiple harness bindings.
--update                 Refresh templates and all detected installed harness bindings.
--update-harness         Refresh harness binding files managed by RedlineSpec.
```

If `--harness` is omitted and stdin/stdout are attached to a terminal, prompt with a simple numbered multi-selection. If `--harness` is omitted in a non-interactive shell, fail with instructions to pass `--harness`.

Optional aliases can be added later if needed:

```txt
--opencode
--windsurf
```

Avoid aliases in the first implementation unless there is an explicit UX need.

### New directories

When `--harness opencode` is used, create:

```txt
.opencode/skills/
.opencode/commands/
```

When `--harness windsurf` is used, create:

```txt
.windsurf/skills/
.windsurf/workflows/
```

### Copy policy

Default harness install:

- copy missing native harness skill folders only,
- copy missing `.opencode/commands/*.md` files only,
- copy missing `.windsurf/workflows/*.md` files only.

With `--update`:

- refresh `.redline/system/templates/`,
- detect installed harnesses from their native paths,
- refresh RedlineSpec-managed files for the detected harnesses only,
- do not install new harnesses that are not already present.

With `--update-harness`:

- refresh RedlineSpec-managed files in the selected harness skill directories and launcher directories,
- if no harness is selected, detect installed harnesses and refresh those only,
- do not remove unrelated user-defined skills, commands, or workflows.

Avoid deleting entire `.opencode/`, `.windsurf/`, `.agents/`, or future harness directories because they may contain user-managed files.

### Managed file safety

The safest first implementation is to overwrite only exact RedlineSpec artifact names during `--update-harness`:

- known RedlineSpec skill names from `REQUIRED_SKILLS`,
- known OpenCode command file names,
- known Windsurf workflow file names.

Do not attempt broad directory cleanup.

## Documentation Changes

Update `docs/en/installation.md` with:

- manual install prompts for harness selection,
- non-interactive install requires `--harness`,
- harness install examples,
- generated target layouts,
- overwrite behavior for `--update`, `--update-system`, and `--update-harness`,
- explicit note that harness-visible skills are the operational copies invoked by agents,
- explicit note that `.redline/system/skills/` is not installed by default and should not be treated as the invocation path.

Update `README.md` with short examples:

```bash
bash scripts/install.sh ~/work/my-project --harness opencode
bash scripts/install.sh ~/work/my-project --harness windsurf
bash scripts/install.sh ~/work/my-project --harness opencode --harness windsurf
bash scripts/install.sh ~/work/my-project --harness opencode,windsurf
bash scripts/install.sh ~/work/my-project --update
```

## Implementation Sequence

1. Add harness adapter manifests for `opencode` and `windsurf`.
2. Add `harnesses/opencode/commands/*.md` thin command launchers.
3. Add `harnesses/windsurf/workflows/*.md` thin workflow launchers.
4. Extend installer argument parsing with `--harness`, `--update`, and `--update-harness`.
5. Add validation that adapter manifests and source artifacts exist before copying.
6. Add a generic `copy_harness_skills_missing_only` that receives the adapter skill path.
7. Add a generic `copy_harness_launchers_missing_only` that receives the adapter launcher path and source path.
8. Add refresh functions that overwrite only RedlineSpec-managed artifact names.
9. Update installation docs and README.
10. Verify by installing into a temporary target repo for each harness mode.

## Open Questions

1. Should harness bindings be committed by default in consumer projects, or should teams add harness folders to `.gitignore` when they want local-only activation?
2. Should `interview-first` be exposed as `/interview` only, or also as `/interview-first` to match the skill name?
3. Should `.agents/skills/` be supported as an optimization flag for compatible harnesses, or avoided until more harnesses are reviewed?

Recommended defaults:

1. Treat harness bindings as project artifacts that can be committed.
2. Expose `/interview` as the user-facing command and keep `interview-first` as the internal skill name.
3. Use native harness skill folders by default; add `.agents/skills/` only as an explicit shared strategy.
