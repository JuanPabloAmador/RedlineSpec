import type { Translation } from './en';

export const es: Translation = {
  meta: {
    title: 'RedlineSpec — Define la arquitectura con contratos',
    description:
      'RedlineSpec es un framework de desarrollo contract-first y spec-driven para flujos de trabajo con agentes de IA. Da forma a la arquitectura definiendo contratos; los agentes rellenan los interiores.',
  },
  header: {
    nav: [
      { href: '#concept', label: 'Concepto' },
      { href: '#flow', label: 'Cómo funciona' },
      { href: '#why', label: 'Por qué' },
      { href: '#install', label: 'Instalar' },
    ],
    github: 'GitHub',
  },
  hero: {
    badge: 'v0.5.1 · desarrollo contract-first para flujos de trabajo con IA',
    titleLead: 'Define la arquitectura',
    titleMark: 'con contratos.',
    sub: 'RedlineSpec es un framework de desarrollo contract-first y spec-driven para flujos de trabajo con agentes de IA. Tú das forma a la arquitectura definiendo entradas, salidas y responsabilidades de cada módulo. Los agentes rellenan los interiores.',
    ctaPrimary: 'Instalar en tu harness',
    ctaSecondary: 'Leer la documentación',
    harnesses: 'Funciona con',
  },
  concept: {
    tag: 'Concepto',
    problemTitle: 'Grandes planes, construcción incierta.',
    problemBody:
      'El spec-driven development es excelente capturando lo que un producto debe hacer. Pero cuando los planes crecen, la técnica muestra su límite: un plan SDD grande describe features y requisitos, mientras la forma técnica que los implementa la decide el agente. Nadie sabe qué va a construir hasta que el código aparece.',
    problemPoints: [
      'Apruebas un plan grande sin una sola frontera técnica concreta',
      'La arquitectura es lo que el agente haya producido',
      'Cuanto más grande es el plan, menos sabes qué se va a construir',
    ],
    solutionTitle: 'La forma, decidida por ti.',
    solutionBody:
      'RedlineSpec expresa la técnica como contratos. Un contrato es la firma de un módulo: entradas, salidas, responsabilidades, invariantes. Cualquier desarrollador entiende un componente de un vistazo — igual que usas una librería sin leer su interior.',
    solutionBody2:
      'Dibujas la arquitectura durante la planificación definiendo solo los contratos. Los agentes implementan dentro de esos límites. Lees el sistema como lees una dependencia: por sus conexiones, no por su código.',
    solutionPoints: [
      'Diseña la arquitectura sin escribir sus interiores',
      'Cada módulo es una caja negra con una firma documentada',
      'Entiende el sistema por sus conexiones — como la arquitectura de una IA',
    ],
  },
  flow: {
    tag: 'Cómo funciona',
    title: 'Un contrato en cada frontera.',
    intro:
      'Cada fase produce y consume un contrato estandarizado de RedlineSpec. La verdad funcional actúa como main en Git; cada spec es una rama que se fusiona de vuelta cuando el cambio termina.',
    steps: [
      {
        title: 'Verdad funcional',
        body: 'El documento vivo de lo que hace tu producto. Tu rama main conceptual.',
      },
      {
        title: 'Spec',
        body: 'Una rama: el contrato de un cambio, acotado contra la verdad actual.',
      },
      {
        title: 'Plan',
        body: 'Firmas técnicas para cada módulo. La arquitectura, escrita como contratos.',
      },
      {
        title: 'Tareas',
        body: 'Una unidad de trabajo cada una, secuenciadas por un árbol de ejecución.',
      },
      {
        title: 'Implementación',
        body: 'Los agentes construyen dentro de los límites que definiste. El código nunca rebasa el contrato.',
      },
      {
        title: 'Fusión',
        body: 'El trabajo verificado se integra en la verdad funcional. Sin verdades paralelas.',
      },
    ],
  },
  why: {
    tag: 'Por qué RedlineSpec',
    title: 'Hecho para agentes, controlado por humanos.',
    cards: [
      {
        title: 'Independiente del harness',
        body: 'Devin, Codex, OpenCode, Pi y Claude comparten los mismos contratos y skills. Sin atarte a un solo agente.',
      },
      {
        title: 'Los contratos son la arquitectura',
        body: 'El conjunto de contratos es la arquitectura. El código es solo el interior de cada módulo.',
      },
      {
        title: 'Firmas antes que interiores',
        body: 'Agentes potentes definen firmas precisas para que cualquier agente pueda implementar dentro de ellas.',
      },
      {
        title: 'Verificable por construcción',
        body: 'Los contratos llevan criterios de aceptación y tests. Lo prometido es lo que se comprueba.',
      },
      {
        title: 'Simplicidad antes que ritual',
        body: 'Rigor concentrado donde rinde: contratos claros, decisiones trazables. Sin burocracia.',
      },
      {
        title: 'Verdad viva, sin cementerio',
        body: 'Los specs son instrumentos de cambio. Al terminar, se fusionan y la verdad sigue vigente.',
      },
    ],
  },
  install: {
    tag: 'Instalar',
    title: 'Instala en tu harness.',
    sub: 'Un comando, no destructivo. Copia las plantillas, scripts y skills que tu harness necesita dentro de tu proyecto.',
    copy: 'Copiar',
    copied: '¡Copiado!',
    after: 'Ejecútalo dentro de tu proyecto y pídele a tu agente que empiece con la skill redlinespec.',
    docsLink: 'Guía de instalación completa',
  },
  footer: {
    tagline: 'Desarrollo contract-first para flujos de trabajo con IA.',
    repo: 'Repositorio en GitHub',
    docs: 'Documentación',
    changelog: 'Changelog',
    license: 'Licencia',
    version: 'v0.5.1',
  },
};
