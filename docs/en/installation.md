# Installing RedlineSpec in a Project

This document defines the target structure and behavior of RedlineSpec's bash installer.

The installer creates RedlineSpec project state, installs framework templates, and can optionally install harness-native bindings for supported agents.

The current local installer implementation lives in:

- `scripts/install.sh`

The remote bootstrap installer lives in:

- `scripts/install-remote.sh`

Local usage:

```bash
bash scripts/install.sh TARGET_PATH [--update] [--update-system] [--harness devin[,codex,opencode,pi,claude]]... [--update-harness]
```

Remote usage:

```bash
curl -fsSL https://raw.githubusercontent.com/JuanPabloAmador/RedlineSpec/main/scripts/install-remote.sh | bash -s -- [TARGET_PATH] [install options]
```

For the local installer, `TARGET_PATH` is required. For the remote installer, `TARGET_PATH` defaults to the current directory when omitted or when the first argument is an option.

A harness selection is also required. In an interactive terminal, the installer prompts for one when `--harness` is omitted. In non-interactive shells, `--harness` must be passed explicitly.

The supported models are:

- run the remote installer directly from GitHub, or
- clone RedlineSpec into a separate location and run the local installer while explicitly pointing to the destination repository.

Remote examples:

```bash
curl -fsSL https://raw.githubusercontent.com/JuanPabloAmador/RedlineSpec/main/scripts/install-remote.sh | bash -s -- --harness pi
curl -fsSL https://raw.githubusercontent.com/JuanPabloAmador/RedlineSpec/main/scripts/install-remote.sh | bash -s -- ~/work/my-project --harness opencode
REDLINESPEC_REF=v0.2.0 curl -fsSL https://raw.githubusercontent.com/JuanPabloAmador/RedlineSpec/main/scripts/install-remote.sh | bash -s -- --harness opencode
```

Local clone example:

```bash
git clone <redlinespec-repo> ~/tools/RedlineSpec
bash ~/tools/RedlineSpec/scripts/install.sh ~/work/my-project
```

For scripts and CI, use an explicit harness:

```bash
bash ~/tools/RedlineSpec/scripts/install.sh ~/work/my-project --harness devin
bash ~/tools/RedlineSpec/scripts/install.sh ~/work/my-project --harness opencode
bash ~/tools/RedlineSpec/scripts/install.sh ~/work/my-project --harness pi
```

When using a local clone, RedlineSpec acts as the source repository for the installer. It must not be embedded inside the user's destination repository. When using the remote installer, the source archive is downloaded to a temporary directory and removed after installation.

## 1. Script goal

The installation script must leave the project with a canonical `.redline/` structure, separating:

- framework-distributed templates,
- deterministic framework scripts,
- and project documents.

The target root is:

```txt
.redline/
  system/
    templates/
    scripts/
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
    scripts/
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
- `plan-technical-unit.template.md`
- `tasks.template.md`
- `task.template.md`
- `functional.index.template.md`
- `functional.entry.template.md`
- `functional.global.entry.template.md`
- `rules.index.template.md`
- `rule.template.md`

The installer validates that the templates required by the minimum flow exist in the source repository before copying assets into the destination project.

#### `.redline/system/scripts/`

Must receive deterministic framework scripts available from the framework.

Currently includes:

- `health-check.sh`

#### Skills

Skills are not installed under `.redline/system/skills/` by default.

The canonical skill source remains the RedlineSpec distribution repository or package:

- `skills/`
- `redline-skills/`

When a harness is selected, the installer copies those skills into the effective skill folder where that agent can discover and invoke them. Shared Agent Skills harnesses install one deduplicated copy into `.agents/skills/`; private-path harnesses install into their own directories.

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
    technical-units/
  tasks/
```

This lets each change group its temporary contracts in a single folder.

## 5. Recommended copy map

Using this framework repository as the source, the installation script should approximately copy:

### Templates

- `templates/spec.template.md` -> `.redline/system/templates/spec.template.md`
- `templates/plan.template.md` -> `.redline/system/templates/plan.template.md`
- `templates/plan-technical-unit.template.md` -> `.redline/system/templates/plan-technical-unit.template.md`
- `templates/tasks.template.md` -> `.redline/system/templates/tasks.template.md`
- `templates/task.template.md` -> `.redline/system/templates/task.template.md`
- `templates/functional.index.template.md` -> `.redline/system/templates/functional.index.template.md`
- `templates/functional.entry.template.md` -> `.redline/system/templates/functional.entry.template.md`
- `templates/functional.global.entry.template.md` -> `.redline/system/templates/functional.global.entry.template.md`
- `templates/rules.index.template.md` -> `.redline/system/templates/rules.index.template.md`
- `templates/rule.template.md` -> `.redline/system/templates/rule.template.md`

### System scripts

- `scripts/health-check.sh` -> `.redline/system/scripts/health-check.sh`

### Skills

Skills are copied only when a harness is selected. The installer resolves selected harnesses to effective skill destinations and copies each destination once.

Shared Agent Skills group (`devin`, `codex`, `opencode`, `pi`):

- `skills/redlinespec/` -> `.agents/skills/redlinespec/`
- `skills/interview/` -> `.agents/skills/interview/`
- `redline-skills/write-spec/` -> `.agents/skills/write-spec/`
- `redline-skills/write-plan/` -> `.agents/skills/write-plan/`
- `redline-skills/write-tasks/` -> `.agents/skills/write-tasks/`
- `redline-skills/write-rules/` -> `.agents/skills/write-rules/`
- `redline-skills/implement/` -> `.agents/skills/implement/`
- `redline-skills/bootstrap-functional-truth/` -> `.agents/skills/bootstrap-functional-truth/`
- `redline-skills/close-spec/` -> `.agents/skills/close-spec/`
- `redline-skills/merge-functional-truth/` -> `.agents/skills/merge-functional-truth/`
- `redline-skills/health-check/` -> `.agents/skills/health-check/`

Private-path harnesses use the same skill set with their own destination prefix:

- Claude -> `.claude/skills/`

Examples:

- `--harness devin` installs only `.agents/skills/`.
- `--harness devin,codex` installs only one `.agents/skills/` copy.
- `--harness devin,opencode` installs only one `.agents/skills/` copy.
- `--harness opencode,pi` installs only one `.agents/skills/` copy.
- `--harness claude` installs only `.claude/skills/`.

If the framework adds new skills or templates, this map must be expanded through the source skill directories and harness adapter manifests.

### Harness launchers

RedlineSpec does not install harness-specific command or workflow launchers.

The canonical runtime surface is the installed Agent Skills under each harness skill directory. OpenCode command wrappers, Devin Desktop launcher files, slash commands, and similar launcher formats are intentionally outside the installer scope. During the temporary cleanup window recorded in `docs/en/deprecations.md`, harness refresh removes old RedlineSpec-managed OpenCode launcher files when it finds them.

## 6. Recommended overwrite policy

The installer should follow this default policy:

- create missing folders,
- copy `system` templates when they do not exist,
- allow an explicit `--update-system` mode to refresh `.redline/system/templates/` and `.redline/system/scripts/`,
- allow an explicit `--update` mode to refresh templates and all detected effective harness skill destinations,
- allow an explicit `--update-harness` mode to refresh selected or detected effective harness skill destinations and remove old RedlineSpec OpenCode launcher files during the temporary cleanup window,
- remove known deprecated RedlineSpec skill folders from selected or detected harness skill directories,
- treat `.redline/system/templates/` and selected effective harness skill folders as framework-managed areas for RedlineSpec artifact names,
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
      plan-technical-unit.template.md
      tasks.template.md
      task.template.md
      functional.index.template.md
      functional.entry.template.md
      functional.global.entry.template.md
      rules.index.template.md
      rule.template.md
    scripts/
      health-check.sh
  project/
    functional-truth/
      functional.index.md
    rules/
      rules.index.md
    specs/
```

## 9. Remote installation

The remote installer is a small bootstrap script intended for `curl | bash` usage. It does not contain the full framework. Instead, it:

1. downloads a RedlineSpec source archive from GitHub,
2. extracts it into a temporary directory,
3. runs the normal `scripts/install.sh`,
4. removes the temporary source directory.

The default source is:

```txt
https://github.com/JuanPabloAmador/RedlineSpec
```

The default ref is:

```txt
main
```

Override them with environment variables:

```bash
REDLINESPEC_REPO_URL=https://github.com/JuanPabloAmador/RedlineSpec \
REDLINESPEC_REF=v0.2.0 \
curl -fsSL https://raw.githubusercontent.com/JuanPabloAmador/RedlineSpec/main/scripts/install-remote.sh | bash -s -- --harness pi
```

For reproducibility, prefer pinning `REDLINESPEC_REF` to a tag or commit in automation.

## 10. Harness installation

Harness bindings are installed only when requested.

Examples:

```bash
bash scripts/install.sh ~/work/my-project --harness devin
bash scripts/install.sh ~/work/my-project --harness devin,codex
bash scripts/install.sh ~/work/my-project --harness opencode
bash scripts/install.sh ~/work/my-project --harness pi
bash scripts/install.sh ~/work/my-project --harness claude
bash scripts/install.sh ~/work/my-project --harness devin,opencode
bash scripts/install.sh ~/work/my-project --harness opencode,pi
```

To refresh an already installed project, including templates and all detected harness bindings:

```bash
bash scripts/install.sh ~/work/my-project --update
```

To refresh one specific harness:

```bash
bash scripts/install.sh ~/work/my-project --harness opencode --update-harness
```

When `--update-harness` is used without `--harness`, the installer detects installed effective skill paths and refreshes those only.

### Shared `.agents` result

```txt
.agents/
  skills/
    redlinespec/
    interview/
    write-spec/
    write-plan/
    write-tasks/
    write-rules/
    implement/
    bootstrap-functional-truth/
    close-spec/
    merge-functional-truth/
    health-check/
```

### Claude result

```txt
.claude/
  skills/
    redlinespec/
    interview/
    write-spec/
    write-plan/
    write-tasks/
    write-rules/
    implement/
    bootstrap-functional-truth/
    close-spec/
    merge-functional-truth/
    health-check/
```

## 11. Current scope of this document

This document establishes the structure and behavior of the current bash installer.

The following concerns are outside the current installer scope:

- possible additional flags such as `--force`,
- global harness installation into user home directories,
- automatic modification of existing user harness configuration files,
- adding harness-specific launchers or slash-command surfaces.
