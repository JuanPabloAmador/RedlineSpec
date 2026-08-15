---
name: health-check
description: >-
  RedlineSpec workflow skill for health-check. Also use for RedlineSpec audit, installation check, framework integrity check, documentation health review, and spec lifecycle hygiene. Use this workflow skill to run deterministic checks and semantic review for .redline structure, templates, scripts, functional truth, rules, specs, and installed harness skills, then report findings and repair guidance. Do not use to make automatic repairs, implement product changes, write contracts, or replace specific workflow execution.
---

# RedlineSpec health-check Workflow

Use this skill to assess whether a RedlineSpec installation is structurally sound and whether its project documentation remains useful as the product evolves.

This workflow has two layers:

1. Run the deterministic health-check script.
2. Review semantic and organizational drift that a script cannot decide safely.

Do not automatically repair files unless the user explicitly asks for fixes after reviewing the report.

## Required Script

Use the installed deterministic script when available:

```txt
.redline/system/scripts/health-check.sh
```

Run it from the target project root or pass the target path explicitly:

```bash
bash .redline/system/scripts/health-check.sh . --json
```

If you are operating from the RedlineSpec distribution repository instead of an installed target, use:

```bash
bash scripts/health-check.sh <target-project> --json
```

If `--json` is not useful in the current harness, run the text form too.

If neither script exists, stop and report that the framework installation is incomplete and should be refreshed.

## Deterministic Checks

The script verifies:

- required `.redline/` directories,
- required system templates,
- installed deterministic system scripts,
- required project indexes,
- broken functional truth index links,
- orphaned functional truth entry files,
- unexpected files in functional truth,
- broken rules index links,
- orphaned rule files,
- unexpected files in rules,
- spec directories missing their canonical `*.spec.md`,
- tasks directories that exist without a plan directory,
- task indexes missing the `Execution Tree` section,
- task indexes still using `parallel_group` from the pre-0.5.0 model,
- detected harness skill installations for shared `.agents/skills/` and Claude.

Treat script `error` findings as blocking installation or structure issues.

## Semantic Review

After reading the script output, inspect relevant files for semantic drift.

Review functional truth for:

- entries that describe framework/process history instead of current product behavior,
- entries named like `bootstrap`, `initial-setup`, `migration`, or `implementation` that may be historical artifacts,
- entries that are too broad and should be split by product domain or module,
- entries that are too narrow and should be merged into a real domain/module entry,
- duplicated behavior across entries,
- implementation details presented as product truth,
- planned behavior presented as current truth,
- stale entries left after specs were merged.

A process-like entry is valid only when it describes a real current product capability. For example, `bootstrap.entry.md` is acceptable if the product has a user-facing or actor-facing bootstrap capability. If it only records that the project was initialized, flag it as stale or misplaced.

Review the functional index for:

- whether it routes to entries instead of absorbing detailed truth,
- whether groupings reflect real product domains such as `admin`, `shopping-cart`, `blog`, or `form-editing`,
- whether entries are named consistently,
- whether global entries truly describe cross-cutting product behavior.

Review rules for:

- rules that are temporary decisions rather than persistent implementation constraints,
- rules that duplicate functional truth,
- vague rules that cannot guide implementation or verification,
- rules that contradict current repository conventions,
- references to outdated files, libraries, or architecture.

Review specs for:

- active specs that appear abandoned,
- implemented specs that were not merged,
- specs whose behavior already appears in functional truth,
- temporary change documents competing with consolidated truth.

Review task indexes for:

- `Execution Tree` sections missing from phases,
- `parallel_group` leftovers from the pre-0.5.0 model,
- trees that do not match the task table: task IDs missing or extra in either place,
- tasks that bundle more than one artifact or functional unit, against the Granularity Decomposition criteria,
- `[∥]` sibling groups whose tasks share files,
- task files that reference other tasks or the tree.

## Classification

Use these severities:

- `error`: deterministic failure or blocking structural problem.
- `warning`: likely issue that can cause drift but may not block all work.
- `advisory`: semantic or organizational concern requiring human judgment.
- `info`: useful observation.

Use these areas:

- `installation`
- `harness`
- `functional-truth`
- `functional-index`
- `rules`
- `specs`
- `tasks`
- `templates`
- `documentation-structure`

## Report Output

Produce a standardized Markdown report. Prefer this location when writing to the target project:

```txt
.redline/project/health/health-check-YYYY-MM-DD.md
```

Create `.redline/project/health/` if needed.

If the user only wants a console report, still use the same structure in your response.

## Report Template

```md
# RedlineSpec Health Check Report

Date: YYYY-MM-DD
Target: <target project path>
Status: pass | warning | fail

## Summary

- Installation integrity: pass | warning | fail
- Harness bindings: pass | warning | fail | not-detected
- Functional truth structure: pass | warning | fail
- Functional truth semantics: pass | warning | fail
- Functional index organization: pass | warning | fail
- Rules health: pass | warning | fail
- Spec lifecycle: pass | warning | fail
- Task index health: pass | warning | fail

## Blocking Issues

| ID | Area | Problem | Location | Suggested Fix | Deterministic |
|----|------|---------|----------|---------------|---------------|

## Warnings

| ID | Area | Problem | Location | Suggested Fix | Deterministic |
|----|------|---------|----------|---------------|---------------|

## Advisory Findings

| ID | Area | Observation | Location | Recommendation |
|----|------|-------------|----------|----------------|

## Orphaned Files

List orphaned functional truth entries or rules reported by the script.

## Broken Links

List broken links reported by the script.

## Stale or Suspicious Functional Truth Entries

List entries that may not represent current product behavior, including process-like entries such as bootstrap/setup/migration when they are historical rather than functional.

## Suggested Repair Plan

1. Fix blocking installation and harness issues.
2. Fix broken links and orphaned indexed files.
3. Review suspicious functional truth entries with the user.
4. Reorganize the functional index around real product domains/modules if needed.
5. Remove or merge stale temporary/process artifacts from functional truth.
6. Re-run `health-check`.

## Machine-Readable Issue List

```yaml
issues:
  - id: RLS-HC-001
    severity: error | warning | advisory | info
    area: functional-truth
    location: .redline/project/functional-truth/functional.index.md
    problem: "Describe the issue."
    suggested_fix: "Describe the proposed repair."
    deterministic: true | false
```
```

## Workflow

1. Identify the target project root.
2. Run `scripts/health-check.sh <target-project> --json`.
3. If the script reports errors, include them as blocking issues.
4. Read the affected indexes and files named by the script.
5. Inspect functional truth, rules, and active specs for semantic drift.
6. Produce the standardized report.
7. Ask the user before applying any repair.

## Completion Criteria

The workflow is complete when the user has a report that another agent can use to repair the installation or documentation later.
