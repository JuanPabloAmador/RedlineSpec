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

`/write-rules` exists to create and maintain persistent project rules.

Rules are not every persistent project decision. A project rule is an atomic, reusable, project-specific implementation or verification constraint that future agents must apply while changing, verifying, or approving code.

Rules are not functional truth, temporary change documents, general documentation, harness/tooling configuration, release procedures, or agent collaboration preferences.

A rule may protect a configuration or documented decision, but only by constraining implementation or verification behavior. For example, "TypeScript strict mode is enabled" is configuration; "do not weaken TypeScript strictness" and "run the TypeScript build before approving a phase" can be rules.

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
9. `domain` and `type` must use the values allowed by the rule template.
10. `rules.index.md` must stay grouped by `domain`, then by `type`, even though the directory is flat.
11. Do not hide multiple unrelated practices inside one rule just for convenience.
12. Prefer imperative, directly applicable wording.
13. Add rationale or examples only when they materially improve correct application of the rule.
14. Keep the rule set easy to expand mechanically into task-level contracts later.
15. Classify each candidate before writing it; only candidates classified as project rules may become `*.rule.md` files.
16. Do not restate project facts, stack choices, or tool settings as rules unless the rule constrains how agents must implement, verify, or approve code around them.

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

### Step 5: Classify candidate rules

Before writing any rule file, classify each candidate as exactly one of:

- project rule,
- harness or tooling configuration,
- documentation,
- `AGENTS.md` or agent preference,
- functional truth,
- temporary change instruction.

Only candidates classified as project rules may be written under `.redline/project/rules/`.

Accept a candidate as a project rule only when all of these are true:

- it constrains how agents implement, structure, model, verify, or approve code,
- it prevents a project-specific implementation mistake or skipped verification,
- it applies across future changes,
- it is not merely restating a fact, preference, procedure, document, or tool setting.

A rule may invoke tooling when it governs agent behavior around that tooling. For example, requiring a TypeScript build before approving a phase is a verification rule; defining the TypeScript compiler options is tooling configuration.

If classification is ambiguous, ask one focused question before writing.

Before accepting a candidate as a project rule, be able to answer clearly:

- What implementation mistake or skipped verification does this prevent?
- When should an agent apply it?
- What code, design, execution, or verification decision does it constrain?
- Why is this not better stored as tooling/configuration, documentation, functional truth, `AGENTS.md`, or a temporary instruction?

If those answers are not clear, do not write the candidate as a rule.

### Step 6: Define each rule correctly

For each rule:

- choose a single concrete practice or restriction,
- choose a file name with domain prefix,
- derive the `id` from the rule base name,
- set `domain` using the template vocabulary,
- set `type` using the template vocabulary,
- and write a short free-Markdown body.

Canonical location:

- `.redline/project/rules/<domain>-<rule-name>.rule.md`

Example:

- `.redline/project/rules/ui-angular-onpush.rule.md`

### Step 7: Keep the body useful and compact

Because the body is free Markdown, you must self-regulate structure.

A good rule body usually does some combination of these:

- state the rule clearly,
- clarify when it applies,
- explain what is required or forbidden,
- clarify key exceptions if they truly matter,
- and give a small example only when needed.

Prefer compact sections when they improve activation by future agents:

- `## Rule`
- `## Applies When`
- `## Do Not`
- `## Rationale`

Do not require every section for every rule, but include `Applies When` when the activation context is not obvious from the title.

Do not let a small rule turn into a general style guide chapter.

### Step 8: Update `rules.index.md`

The index file is mandatory.

Path:

- `.redline/project/rules/rules.index.md`

Rules:

- keep the directory flat,
- group the index by `domain`, then by `type`,
- link to each rule file,
- and use the rule title in each entry.

### Step 9: Validate the set

Before finalizing, verify:

- every rule is in English,
- every rule is atomic,
- every rule has the required frontmatter fields,
- every `domain` and `type` value is allowed by the rule template,
- the file name uses a domain prefix,
- the index includes the created or updated rules,
- the index grouping follows `domain -> type`,
- no rule is just a temporary instruction from a single implementation change,
- no rule is merely documentation, harness/tooling configuration, release procedure, functional truth, or agent preference,
- and every rule constrains implementation or verification behavior that future agents must apply while changing, verifying, or approving code.

### Step 10: Write or update the files

Create or update:

- `.redline/project/rules/rules.index.md`
- the relevant `*.rule.md` files

If the user asked only for the content first, present the draft before writing. Otherwise write the files directly when appropriate.

## Special Case: Bootstrapping the Rules Catalog

When the user wants an initial rules system for a project:

1. inspect the repository,
2. identify the smallest useful initial rule set that passes the project-rule classification filter,
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
- and implementation constraints that later plans can reference cleanly.

## Final Checklist

Before finishing, confirm all of these:

- Every written candidate passed the project-rule classification filter.
- Rule files are flat under `.redline/project/rules/`, use domain-prefixed names, and have exactly the required frontmatter.
- Rule bodies are atomic, reusable, concise, and implementation- or verification-constraining.
- `rules.index.md` exists, is grouped by domain then type, and links to real rule files.

## What Not To Do

Do not:

- write giant multi-topic rules,
- turn one temporary implementation choice into a permanent project rule without justification,
- turn stack choices, tooling settings, release procedures, documentation, or collaboration preferences into rules,
- hide required metadata in the body instead of frontmatter,
- create nested rule directories,
- or leave the index out of sync with the rule files.
