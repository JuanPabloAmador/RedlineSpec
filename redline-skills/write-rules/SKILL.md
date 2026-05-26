---
name: write-rules
description: Execute the RedlineSpec /write-rules workflow. Use when the project needs to initialize, add, refine, or reorganize persistent project rules under .redline/project/rules/.
---

# RedlineSpec /write-rules Workflow

Use this skill to execute the operational workflow for writing RedlineSpec project rules.

This workflow can be used to:

- initialize the rules system for a project,
- define a single new rule,
- define several rules in one pass,
- refine existing rules,
- or rebuild `rules.index.md` after rule changes.

## Read First

Before doing anything else, read these files:

- `.redline/system/templates/rule.template.md`
- `.redline/system/templates/rules.index.template.md`

When available, also read:

- `.redline/project/rules/rules.index.md`
- the relevant existing `*.rule.md` files
- the repository code or conventions that motivate the rules
- any plan or supporting context that explains why new rules are needed

This workflow must stay portable. At runtime it should depend only on the distributed templates, the rules embedded in this skill, the project rule files, and the repository itself.

Template resolution is installation-relative: locate the target project root that contains `.redline/system/templates/`, then read templates from that directory. If a required template is missing, stop and report that the RedlineSpec system installation is incomplete or must be refreshed.

## Purpose of /write-rules

`/write-rules` exists to create and maintain the persistent technical rules of a project.

A project rule is:

- persistent,
- project-specific,
- atomic,
- reusable,
- and suitable for later expansion into task-level execution contracts.

Rules are not functional truth and are not temporary change documents.

They live under:

- `.redline/project/rules/`

## Embedded Contract Rules

Always apply these rules:

1. Keep rules in English.
2. Keep each rule atomic and reusable.
3. Do not encode change-specific temporary instructions as persistent project rules.
4. Use frontmatter with exactly these fields: `id`, `title`, `domain`, `type`.
5. The rule body is free Markdown, but it should stay focused and concise.
6. Rule files live flat under `.redline/project/rules/`.
7. Rule file names must use a domain prefix, for example `ui-angular-onpush.rule.md`.
8. The `id` should derive from the rule base name.
9. `rules.index.md` must stay grouped by `domain`, then by `type`, even though the directory is flat.
10. Do not hide multiple unrelated practices inside one rule just for convenience.
11. Prefer imperative, directly applicable wording.
12. Add rationale or examples only when they materially improve correct application of the rule.
13. Keep the rule set easy to expand mechanically into task-level contracts later.

## When To Use This Skill

Use this skill when:

- the user wants `/write-rules`,
- the project still lacks its initial rules catalog,
- a new plan needs a rule that does not exist yet,
- existing project rules must be refined,
- or `rules.index.md` is outdated.

## Workflow

Follow this sequence.

### Step 1: Load the rule shapes

Read:

- `.redline/system/templates/rule.template.md`
- `.redline/system/templates/rules.index.template.md`

Treat those templates and the rules embedded in this skill as canonical.

### Step 2: Load the current project rule state

If the project already has rules, read:

- `.redline/project/rules/rules.index.md`
- the relevant `*.rule.md` files

If the rules system does not exist yet, prepare to create:

- `.redline/project/rules/rules.index.md`
- one or more `*.rule.md` files

### Step 3: Determine the requested scope

Clarify whether the task is:

- initializing a full starter rule set,
- adding one rule,
- adding several rules,
- refining one or more existing rules,
- or only repairing the index.

If the user has not specified enough scope, ask only the minimum necessary follow-up questions.

### Step 4: Inspect the real repository conventions

Do not invent rules in a vacuum when the repository can answer the question.

Inspect the relevant code, architecture, tests, or naming conventions when necessary.

The goal is to write project rules that actually match the repository and the intended working style.

### Step 5: Define each rule correctly

For each rule:

- choose a single concrete practice or restriction,
- choose a file name with domain prefix,
- derive the `id` from the rule base name,
- set `domain`,
- set `type`,
- and write a short free-Markdown body.

Canonical location:

- `.redline/project/rules/<domain>-<rule-name>.rule.md`

Example:

- `.redline/project/rules/ui-angular-onpush.rule.md`

### Step 6: Keep the body useful and compact

Because the body is free Markdown, you must self-regulate structure.

A good rule body usually does some combination of these:

- state the rule clearly,
- explain what is required or forbidden,
- clarify key exceptions if they truly matter,
- and give a small example only when needed.

Do not let a small rule turn into a general style guide chapter.

### Step 7: Update `rules.index.md`

The index file is mandatory.

Path:

- `.redline/project/rules/rules.index.md`

Rules:

- keep the directory flat,
- group the index by `domain`, then by `type`,
- link to each rule file,
- and use the rule title in each entry.

### Step 8: Validate the set

Before finalizing, verify:

- every rule is in English,
- every rule is atomic,
- every rule has the required frontmatter fields,
- the file name uses a domain prefix,
- the index includes the created or updated rules,
- the index grouping follows `domain -> type`,
- and no rule is just a temporary instruction from a single implementation change.

### Step 9: Write or update the files

Create or update:

- `.redline/project/rules/rules.index.md`
- the relevant `*.rule.md` files

If the user asked only for the content first, present the draft before writing. Otherwise write the files directly when appropriate.

## Special Case: Bootstrapping the Rules Catalog

When the user wants an initial rules system for a project:

1. inspect the repository,
2. identify the smallest useful initial rule set,
3. prefer a few solid rules over a large vague catalog,
4. create `rules.index.md`,
5. create the rule files,
6. and keep the rules reusable across future changes.

## Output Expectations

A good result from this workflow is:

- a valid `.redline/project/rules/rules.index.md`,
- one or more valid `*.rule.md` files,
- flat physical storage,
- grouped logical navigation in the index,
- and rules that later plans can reference cleanly.

## Final Checklist

Before finishing, confirm all of these:

- Rule files live under `.redline/project/rules/`.
- The directory is physically flat.
- File names use a domain prefix.
- Frontmatter fields are exactly `id`, `title`, `domain`, `type`.
- Bodies are free Markdown.
- Rules are atomic and reusable.
- `rules.index.md` exists and is updated.
- The index is grouped by domain, then type.
- Entries link to real files and use their titles.
- No rule is merely a temporary task instruction.

## What Not To Do

Do not:

- write giant multi-topic rules,
- turn one temporary implementation choice into a permanent project rule without justification,
- hide required metadata in the body instead of frontmatter,
- create nested rule directories,
- or leave the index out of sync with the rule files.
