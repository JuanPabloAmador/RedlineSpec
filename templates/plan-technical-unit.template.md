---
id: {{TU-01}}
title: {{Technical unit title}}
status: draft
spec: .redline/project/specs/{{change-base-name}}/{{change-base-name}}.spec.md
plan: .redline/project/specs/{{change-base-name}}/plan/{{change-base-name}}.plan.md
block: {{TB-1}}
type: module | service | component-group | endpoint-group | controller | repository | model | hook | utility | other
# type is the module-level role in the dependency graph. Prefer `module` / `service` / `component-group` / `endpoint-group` for cohesive capabilities.
---

# {{Technical unit title}}

## Source Trace

### Spec

- `.redline/project/specs/{{change-base-name}}/{{change-base-name}}.spec.md`
- {{FB/FR references addressed by this unit}}

### Plan Index

- `.redline/project/specs/{{change-base-name}}/plan/{{change-base-name}}.plan.md`
- {{TB reference}}

### Rules

- `.redline/project/rules/{{rule-name}}.rule.md`
- `.redline/project/rules/{{rule-name}}.rule.md`

## Responsibility

{{Describe what this cohesive module/capability is responsible for as a graph node. One TU = one module with one responsibility and one lifecycle.}}

<!-- Example: `Login Service` owns `src/auth/login.service.ts` + `src/auth/login.types.ts` + `src/auth/session.store.ts` because they share invariants. -->

## Affected Artifacts

<!-- A TU is module-level and may own several cohesive artifacts. List all files/areas that move together as one module. -->

### Existing Artifacts

- `{{path/to/existing-file-or-area}}`
- `{{path/to/existing-dir-or-glob/**}}`

### New Artifacts

- `{{expected/path/to/new-file}}`
- `{{allowed/path/pattern/**}}`

<!-- Use `None.` for either subsection when appropriate. -->

## Inputs

- {{Input shape / source / type}}
- {{Input shape / source / type}}

## Outputs

- {{Output shape / effect / type}}
- {{Output shape / effect / type}}

## Dependencies

<!-- Module-graph edges: declare other TUs/modules this TU depends on or collaborates with. A viewer should be able to draw the Plan as a directed graph from these edges. -->

- {{TU-02 — reason / interface / event — e.g., `TU-02 Session Store — injected token store`}}
- {{External/package dependency — e.g., `postgres` / `jwt library`}}

## Public Surface

<!-- Module public surface: the API other TUs depend on (re-exported types, service interface, events). -->

- `{{public signature — e.g., class LoginService { login(...): Promise<Session> } }}`
- `{{exported type / event / endpoint group}}`

## Key Internal Functions

- `{{internal signature — only those that constrain the module contract}}`
- `{{internal signature}}`

## Contract Shapes

```ts
{{signature, schema, DTO, event, props, return type, or other implementation-constraining shape}}
```

## Relevant Rules

### `.redline/project/rules/{{rule-name}}.rule.md`

{{Rule reference or concise relevant constraint for this unit.}}

If no rules apply:

```txt
None.
```

## Supporting Context

<!-- Include only if needed. -->

- [{{path-to-supporting-context.md}}]({{path-to-supporting-context.md}}) — {{What this context document is for}}

## Open Questions

<!-- Omit if not applicable. If any open question remains, status should stay draft. -->

- {{Open technical question local to this unit}}
