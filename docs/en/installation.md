# Installing RedlineSpec in a Project

This document defines the target structure and behavior of RedlineSpec's current bash installer.

It does not yet describe a user-facing command integrated into a specific harness. It describes what the installer creates and copies inside the user's repository.

The current implementation lives in:

- `scripts/install.sh`

Current usage:

```bash
bash scripts/install.sh TARGET_PATH [--update-system]
```

`TARGET_PATH` is required.

The expected model is:

- clone RedlineSpec into a separate location,
- and run the installer while explicitly pointing to the destination repository.

Example:

```bash
git clone <redlinespec-repo> ~/tools/RedlineSpec
bash ~/tools/RedlineSpec/scripts/install.sh ~/work/my-project
```

RedlineSpec acts as the source repository for the installer. It must not be embedded inside the user's destination repository.

## 1. Script goal

The installation script must leave the project with a canonical `.redline/` structure, separating:

- framework-distributed internals,
- and project documents.

The target root is:

```txt
.redline/
  system/
    templates/
    skills/
  project/
    functional-truth/
    rules/
    specs/
```

## 2. Installer principles

The installer must follow these principles:

- avoid polluting the repository root with framework artifacts,
- keep all of RedlineSpec self-contained inside `.redline/`,
- clearly separate `system` from `project`,
- keep the RedlineSpec source repository separate from the user's destination repository,
- create a predictable structure for agents and scripts,
- be idempotent as far as possible,
- and not overwrite real project documents without an explicit policy.

## 3. Structure it must create

The script must create, at minimum:

```txt
.redline/
  system/
    templates/
    skills/
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

#### `.redline/system/skills/`

Must receive the skills distributed by the framework.

Currently includes at minimum:

- `interview-first/`
- `write-spec/`
- `redlinespec-spec-authoring/`
- `write-plan/`
- `write-tasks/`
- `write-rules/`
- `implement/`
- `bootstrap-functional-truth/`
- `close-spec/`
- `merge-functional-truth/`

If the framework distributes more skills in the future, the installer must be able to add them without breaking the base structure.

The installer validates that the templates and workflows required by the minimum flow exist in the source repository before copying assets into the destination project.

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

- `skills/interview-first/` -> `.redline/system/skills/interview-first/`
- `redline-skills/write-spec/` -> `.redline/system/skills/write-spec/`
- `redline-skills/redlinespec-spec-authoring/` -> `.redline/system/skills/redlinespec-spec-authoring/`
- `redline-skills/write-plan/` -> `.redline/system/skills/write-plan/`
- `redline-skills/write-tasks/` -> `.redline/system/skills/write-tasks/`
- `redline-skills/write-rules/` -> `.redline/system/skills/write-rules/`
- `redline-skills/implement/` -> `.redline/system/skills/implement/`
- `redline-skills/bootstrap-functional-truth/` -> `.redline/system/skills/bootstrap-functional-truth/`
- `redline-skills/close-spec/` -> `.redline/system/skills/close-spec/`
- `redline-skills/merge-functional-truth/` -> `.redline/system/skills/merge-functional-truth/`

If the framework adds new skills or templates, this map must be expanded while keeping the same `system/templates` and `system/skills` separation.

## 6. Recommended overwrite policy

The installer should follow this default policy:

- create missing folders,
- copy `system` assets when they do not exist,
- allow an explicit `--update-system` mode to refresh `system` assets,
- treat `.redline/system/` as an area managed by the framework,
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
  project/
    functional-truth/
      functional.index.md
    rules/
      rules.index.md
    specs/
```

## 9. Current scope of this document

This document establishes the structure and behavior of the current bash installer.

The following concerns are outside the 0.1.0 installer scope:

- specific integrations with concrete harnesses,
- possible additional flags such as `--force`,
- automatic installation or update of harness-specific configurations,
- and additional harness-specific command bindings for the distributed skills.
