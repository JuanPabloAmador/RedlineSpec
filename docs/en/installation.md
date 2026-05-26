# Installing RedlineSpec in a Project

This document defines the target structure and behavior of RedlineSpec's bash installer.

The installer creates RedlineSpec project state, installs framework templates, and can optionally install harness-native bindings for supported agents.

The current implementation lives in:

- `scripts/install.sh`

Current usage:

```bash
bash scripts/install.sh TARGET_PATH [--update] [--update-system] [--harness opencode[,windsurf]]... [--update-harness]
```

`TARGET_PATH` is required.

A harness selection is also required. In an interactive terminal, the installer prompts for one when `--harness` is omitted. In non-interactive shells, `--harness` must be passed explicitly.

The expected model is:

- clone RedlineSpec into a separate location,
- and run the installer while explicitly pointing to the destination repository.

Example:

```bash
git clone <redlinespec-repo> ~/tools/RedlineSpec
bash ~/tools/RedlineSpec/scripts/install.sh ~/work/my-project
```

For scripts and CI, use an explicit harness:

```bash
bash ~/tools/RedlineSpec/scripts/install.sh ~/work/my-project --harness opencode
```

RedlineSpec acts as the source repository for the installer. It must not be embedded inside the user's destination repository.

## 1. Script goal

The installation script must leave the project with a canonical `.redline/` structure, separating:

- framework-distributed templates,
- and project documents.

The target root is:

```txt
.redline/
  system/
    templates/
  project/
    functional-truth/
    rules/
    specs/
```

## 2. Installer principles

The installer must follow these principles:

- avoid polluting the repository root with framework artifacts,
- keep RedlineSpec project state self-contained inside `.redline/`,
- clearly separate `system` from `project`,
- keep the RedlineSpec source repository separate from the user's destination repository,
- create a predictable structure for agents and scripts,
- install skills only into harness-visible folders when a harness is explicitly selected,
- require a harness selection through `--harness` or an interactive prompt,
- be idempotent as far as possible,
- and not overwrite real project documents without an explicit policy.

## 3. Structure it must create

The script must create, at minimum:

```txt
.redline/
  system/
    templates/
  project/
    functional-truth/
    rules/
    specs/
```

### 3.1 `.redline/system/`

Contains the artifacts distributed by the framework.

#### `.redline/system/templates/`

Must receive the official templates available from the framework.

Currently includes at minimum:

- `spec.template.md`
- `plan.template.md`
- `tasks.template.md`
- `task.template.md`
- `functional.index.template.md`
- `functional.entry.template.md`
- `functional.global.entry.template.md`
- `rules.index.template.md`
- `rule.template.md`

The installer validates that the templates required by the minimum flow exist in the source repository before copying assets into the destination project.

#### Skills

Skills are not installed under `.redline/system/skills/` by default.

The canonical skill source remains the RedlineSpec distribution repository or package:

- `skills/`
- `redline-skills/`

When a harness is selected, the installer copies those skills into the harness-native skill folder where that agent can discover and invoke them.

### 3.2 `.redline/project/`

Contains the project's real documents.

#### `.redline/project/functional-truth/`

Must always be created.

Additionally, the installer must initialize:

- `.redline/project/functional-truth/functional.index.md`

using the official `functional.index.template.md` template when the file does not exist yet.

#### `.redline/project/rules/`

Must always be created.

Additionally, the installer must initialize:

- `.redline/project/rules/rules.index.md`

using the official `rules.index.template.md` template when the file does not exist yet.

Individual `*.rule.md` rules will be created later as needed.

#### `.redline/project/specs/`

Must always be created.

It must not be populated with fake changes during installation.

Per-change folders are created on demand when a workflow opens a new `Spec`.

## 4. Expected change structure

Although the installer must not create example changes, it must assume this target structure for future workflows:

```txt
.redline/project/specs/<change>/
  <change>.spec.md
  plan/
    <change>.plan.md
  tasks/
```

This lets each change group its temporary contracts in a single folder.

## 5. Recommended copy map

Using this framework repository as the source, the installation script should approximately copy:

### Templates

- `templates/spec.template.md` -> `.redline/system/templates/spec.template.md`
- `templates/plan.template.md` -> `.redline/system/templates/plan.template.md`
- `templates/tasks.template.md` -> `.redline/system/templates/tasks.template.md`
- `templates/task.template.md` -> `.redline/system/templates/task.template.md`
- `templates/functional.index.template.md` -> `.redline/system/templates/functional.index.template.md`
- `templates/functional.entry.template.md` -> `.redline/system/templates/functional.entry.template.md`
- `templates/functional.global.entry.template.md` -> `.redline/system/templates/functional.global.entry.template.md`
- `templates/rules.index.template.md` -> `.redline/system/templates/rules.index.template.md`
- `templates/rule.template.md` -> `.redline/system/templates/rule.template.md`

### Skills

Skills are copied only when a harness is selected.

For OpenCode:

- `skills/interview-first/` -> `.opencode/skills/interview-first/`
- `redline-skills/write-spec/` -> `.opencode/skills/write-spec/`
- `redline-skills/redlinespec-spec-authoring/` -> `.opencode/skills/redlinespec-spec-authoring/`
- `redline-skills/write-plan/` -> `.opencode/skills/write-plan/`
- `redline-skills/write-tasks/` -> `.opencode/skills/write-tasks/`
- `redline-skills/write-rules/` -> `.opencode/skills/write-rules/`
- `redline-skills/implement/` -> `.opencode/skills/implement/`
- `redline-skills/bootstrap-functional-truth/` -> `.opencode/skills/bootstrap-functional-truth/`
- `redline-skills/close-spec/` -> `.opencode/skills/close-spec/`
- `redline-skills/merge-functional-truth/` -> `.opencode/skills/merge-functional-truth/`

For Windsurf:

- `skills/interview-first/` -> `.windsurf/skills/interview-first/`
- `redline-skills/write-spec/` -> `.windsurf/skills/write-spec/`
- `redline-skills/redlinespec-spec-authoring/` -> `.windsurf/skills/redlinespec-spec-authoring/`
- `redline-skills/write-plan/` -> `.windsurf/skills/write-plan/`
- `redline-skills/write-tasks/` -> `.windsurf/skills/write-tasks/`
- `redline-skills/write-rules/` -> `.windsurf/skills/write-rules/`
- `redline-skills/implement/` -> `.windsurf/skills/implement/`
- `redline-skills/bootstrap-functional-truth/` -> `.windsurf/skills/bootstrap-functional-truth/`
- `redline-skills/close-spec/` -> `.windsurf/skills/close-spec/`
- `redline-skills/merge-functional-truth/` -> `.windsurf/skills/merge-functional-truth/`

If the framework adds new skills or templates, this map must be expanded through the source skill directories and harness adapter manifests.

### Harness launchers

OpenCode launchers are copied from:

- `harnesses/opencode/commands/` -> `.opencode/commands/`

Windsurf launchers are copied from:

- `harnesses/windsurf/workflows/` -> `.windsurf/workflows/`

## 6. Recommended overwrite policy

The installer should follow this default policy:

- create missing folders,
- copy `system` templates when they do not exist,
- allow an explicit `--update-system` mode to refresh `.redline/system/templates/`,
- allow an explicit `--update` mode to refresh templates and all detected harness-native bindings,
- allow an explicit `--update-harness` mode to refresh selected or detected harness-native skills and launchers,
- treat `.redline/system/templates/` and selected harness binding folders as framework-managed areas for RedlineSpec artifact names,
- do not overwrite existing documents under `.redline/project/` by default,
- do not regenerate `functional.index.md` if the project has already edited it, unless the user asks for it,
- and do not regenerate `rules.index.md` if the project has already edited it, unless the user asks for it.

## 7. Expected minimum idempotency

If the script is run multiple times, it should:

- leave the already valid structure intact,
- not duplicate folders,
- not create fake temporary changes,
- and not destroy persistent project documents.

## 8. Minimum expected result after installation

After a correct minimum installation, the repository should look at least like this:

```txt
.redline/
  system/
    templates/
      spec.template.md
      plan.template.md
      tasks.template.md
      task.template.md
      functional.index.template.md
      functional.entry.template.md
      functional.global.entry.template.md
      rules.index.template.md
      rule.template.md
  project/
    functional-truth/
      functional.index.md
    rules/
      rules.index.md
    specs/
```

## 9. Harness installation

Harness bindings are installed only when requested.

Examples:

```bash
bash scripts/install.sh ~/work/my-project --harness opencode
bash scripts/install.sh ~/work/my-project --harness windsurf
bash scripts/install.sh ~/work/my-project --harness opencode --harness windsurf
bash scripts/install.sh ~/work/my-project --harness opencode,windsurf
```

To refresh an already installed project, including templates and all detected harness bindings:

```bash
bash scripts/install.sh ~/work/my-project --update
```

To refresh one specific harness:

```bash
bash scripts/install.sh ~/work/my-project --harness opencode --update-harness
```

When `--update-harness` is used without `--harness`, the installer detects installed harnesses from their native paths and refreshes those only.

### OpenCode result

```txt
.opencode/
  skills/
    interview-first/
    write-spec/
    redlinespec-spec-authoring/
    write-plan/
    write-tasks/
    write-rules/
    implement/
    bootstrap-functional-truth/
    close-spec/
    merge-functional-truth/
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

### Windsurf result

```txt
.windsurf/
  skills/
    interview-first/
    write-spec/
    redlinespec-spec-authoring/
    write-plan/
    write-tasks/
    write-rules/
    implement/
    bootstrap-functional-truth/
    close-spec/
    merge-functional-truth/
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

## 10. Current scope of this document

This document establishes the structure and behavior of the current bash installer.

The following concerns are outside the current installer scope:

- possible additional flags such as `--force`,
- global harness installation into user home directories,
- automatic modification of existing user harness configuration files,
- and shared `.agents/skills/` optimization for harnesses that support the common agent-skills convention.
