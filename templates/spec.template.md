---
id: {{change-base-name}}
title: {{human-readable title}}
status: draft
based_on:
  - .redline/project/functional-truth/functional.index.md
  - .redline/project/functional-truth/{{relevant-functional-document.md}}
affects:
  - .redline/project/functional-truth/{{affected-functional-document.md}}
---

# {{title}}

## Problem

{{Describe the functional problem being solved}}
<!-- Use "Implicit" or "N/A" if appropriate -->

## Objective

{{Describe the intended functional outcome}}
<!-- Use "Implicit" or "N/A" if appropriate -->

## Out of Scope

- {{Explicitly excluded change}}
- {{Explicitly excluded change}}

## Pending to Reach Ready

- {{Open functional decision}}
- {{Open functional decision}}

<!-- Present only when status: draft -->

## Global Constraints and Conditions

- {{Constraint or condition affecting the whole spec}}
- {{Constraint or condition affecting the whole spec}}

<!-- Omit if not applicable -->

## Functional Blocks

### FB-1. {{Block title}}

**Change Type:** add | modify | remove

#### Functional References

- {{functional document reference relevant to this block}}
- {{functional document reference relevant to this block}}

<!-- Omit if not needed -->

#### Context Needed

{{Only include the minimum existing functional context required to understand this block}}

<!-- Omit if not needed -->

#### Block Constraints and Conditions

- {{Constraint specific to this block}}
- {{Constraint specific to this block}}

<!-- Omit if not applicable -->

#### Requirements

- FR-1.1 {{Verifiable functional requirement}}
- FR-1.2 {{Verifiable functional requirement}}

#### Key Scenarios

- {{Scenario that clarifies expected behavior}}
- {{Scenario that clarifies expected behavior}}

<!-- Omit if not needed -->

#### Acceptance Criteria

- {{Block-level acceptance criterion}}
- {{Block-level acceptance criterion}}

### FB-2. {{Block title}}

**Change Type:** add | modify | remove

#### Requirements

- FR-2.1 {{Verifiable functional requirement}}
- FR-2.2 {{Verifiable functional requirement}}

#### Acceptance Criteria

- {{Block-level acceptance criterion}}
- {{Block-level acceptance criterion}}

## Implemented Result

<!-- Present only when status: implemented -->

### Implementation Summary

{{Summarize what was actually implemented}}

### Relevant Differences from Proposed Change

- {{Relevant difference}}
- {{Relevant difference}}

### Impact on Functional Truth

- .redline/project/functional-truth/functional.index.md
- .redline/project/functional-truth/{{impacted-functional-document.md}}
- .redline/project/functional-truth/{{impacted-functional-document.md}}
