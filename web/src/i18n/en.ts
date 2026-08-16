export const en = {
  meta: {
    title: 'RedlineSpec — Define the architecture with contracts',
    description:
      'RedlineSpec is a contract-first, specification-driven development framework for AI coding workflows. Shape the architecture by defining contracts; agents fill in the interiors.',
  },
  header: {
    nav: [
      { href: '#concept', label: 'Concept' },
      { href: '#flow', label: 'How it works' },
      { href: '#why', label: 'Why' },
      { href: '#install', label: 'Install' },
    ],
    github: 'GitHub',
  },
  hero: {
    badge: 'v0.5.1 · contract-first development for AI coding workflows',
    titleLead: 'Define the architecture',
    titleMark: 'with contracts.',
    sub: 'RedlineSpec is a contract-first, specification-driven development framework for AI coding workflows. You give the architecture its shape by defining the inputs, outputs and responsibilities of every module. Agents fill in the interiors.',
    ctaPrimary: 'Install in your harness',
    ctaSecondary: 'Read the docs',
    harnesses: 'Works with',
  },
  concept: {
    tag: 'Concept',
    problemTitle: 'Big plans, unknown build.',
    problemBody:
      'Spec-driven development is excellent at capturing what a product must do. But when plans get large, the technique shows its limit: a big SDD plan describes features and requirements, while the technical shape that implements them is decided by the agent. Nobody knows what it is going to build until the code appears.',
    problemPoints: [
      'You approve a large plan without a single concrete technical boundary',
      'The architecture is whatever the agent happened to produce',
      'The bigger the plan, the less you know about what will be built',
    ],
    solutionTitle: 'The shape, decided by you.',
    solutionBody:
      'RedlineSpec expresses technique as contracts. A contract is a module\'s signature: inputs, outputs, responsibilities, invariants. Any developer understands a component at a glance — the same way you use a library without reading its internals.',
    solutionBody2:
      'You draw the architecture during planning by defining only the contracts. Agents implement inside those boundaries. You read the system the way you read a dependency: by its connections, not its code.',
    solutionPoints: [
      'Design the architecture without writing its interiors',
      'Every module is a black box with a documented signature',
      'Understand the system by its connections — like an AI\'s architecture',
    ],
  },
  flow: {
    tag: 'How it works',
    title: 'A contract at every boundary.',
    intro:
      'Every phase produces and consumes a standardized RedlineSpec contract. The functional truth acts like main in Git; each spec is a branch that merges back when the change is done.',
    steps: [
      {
        title: 'Functional truth',
        body: 'The living document of what your product does. Your conceptual main branch.',
      },
      {
        title: 'Spec',
        body: 'A branch: the contract for one change, scoped against the current truth.',
      },
      {
        title: 'Plan',
        body: 'Technical signatures for every module. The architecture, written as contracts.',
      },
      {
        title: 'Tasks',
        body: 'One unit of work each, sequenced by an execution tree.',
      },
      {
        title: 'Implementation',
        body: 'Agents build inside the boundaries you defined. Code never outruns the contract.',
      },
      {
        title: 'Merge',
        body: 'Verified work folds back into the functional truth. No competing truths.',
      },
    ],
  },
  why: {
    tag: 'Why RedlineSpec',
    title: 'Built for agents, controlled by humans.',
    cards: [
      {
        title: 'Harness-agnostic',
        body: 'Devin, Codex, OpenCode, Pi and Claude share the same contracts and skills. No lock-in to a single agent.',
      },
      {
        title: 'Contracts are the architecture',
        body: 'The set of contracts is the architecture. The code is only the interior of each module.',
      },
      {
        title: 'Signatures before internals',
        body: 'Stronger agents define precise signatures so any agent can implement within them.',
      },
      {
        title: 'Verifiable by construction',
        body: 'Contracts carry acceptance criteria and tests. What was promised is what gets checked.',
      },
      {
        title: 'Simplicity over ritual',
        body: 'Rigor concentrated where it pays: clear contracts, traceable decisions. No bureaucracy.',
      },
      {
        title: 'Living truth, no graveyard',
        body: 'Specs are instruments of change. When done, they merge and the truth stays current.',
      },
    ],
  },
  install: {
    tag: 'Install',
    title: 'Install in your harness.',
    sub: 'One command, non-destructive. It copies the templates, scripts and skills your harness needs into your project.',
    copy: 'Copy',
    copied: 'Copied!',
    after: 'Run it inside your project, then ask your agent to start with the redlinespec skill.',
    docsLink: 'Full installation guide',
  },
  footer: {
    tagline: 'Contract-first development for AI coding workflows.',
    repo: 'GitHub repository',
    docs: 'Documentation',
    changelog: 'Changelog',
    license: 'License',
    version: 'v0.5.1',
  },
};

export type Translation = typeof en;
