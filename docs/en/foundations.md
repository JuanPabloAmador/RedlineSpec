# Foundational Ideas of RedlineSpec

RedlineSpec is a Spec Driven Development framework oriented toward development flows with AI agents. Its central premise is that development should be organized around contracts defined by the framework itself: standardized documents and templates that allow information to be transmitted between phases without depending on how that information was obtained.

The goal is not to impose a single method for discovering, analyzing, planning, or implementing software. The goal is to define clear interfaces between those activities so humans, agents, and tools can collaborate while speaking the same language.

## 1. Contracts as the framework's axis

Each phase of the process must produce and consume contracts defined by RedlineSpec.

A contract is a standardized RedlineSpec document that establishes how one phase should communicate with the next. The main value of the framework is in defining the shape of those contracts: what information they contain, how it is structured, which decisions must be explicit, and which verifiable expectations they transmit.

What matters is not how the contract content is generated. It may come from interviews, code exploration, product decisions, technical research, prompts, human sessions, or autonomous agents. What matters is that, once produced, it fits the shape defined by RedlineSpec so the next phase can use it without reinterpreting all the previous context.

This idea is inspired by APIs. In an API, the client does not need to know how the server obtains or calculates the response. What matters is that client and server share a communication contract: inputs, outputs, errors, constraints, and expectations. RedlineSpec applies the same principle to the complete development flow.

## 2. Information between phases must be standardized

Development phases may change, but transmission between phases must be explicit.

A functional specification must be able to feed technical planning. Technical planning must be able to feed implementation. Implementation must be checkable against what was expected from it. For this to be possible, every boundary between phases must have clear contracts.

RedlineSpec must not depend on an agent remembering all previous reasoning or on a human reading long conversations to reconstruct intent. Important knowledge must be consolidated into RedlineSpec documents with a known structure.

## 3. Functional truth as a Git analogy

In implementation, the source of truth is the code. However, at a higher level there is also a functional truth: the set of capabilities that make up an application.

For example, in an ecommerce application, the `profile` feature may include personal data, addresses, preferences, history, security, and permissions. That functional reality should be describable in a living document that represents what the application does from a product perspective.

RedlineSpec should treat that functional document as a kind of conceptual `main`:

- The application's functional document represents the consolidated truth.
- A new spec works as a branch that diverges from that truth to propose a change.
- During development, the spec guides planning and implementation.
- At the end, the spec should not be preserved as a parallel truth.
- The result must be integrated back into the functional document, just as a branch is merged into `main`.

This avoids accumulating historical specifications that compete with the product's current reality. Specs are instruments of change; the consolidated functional truth must be updated when the change is complete.

## 4. Operational simplicity

The framework's usefulness depends on its simplicity.

A huge flow that reviews a thousand things may seem robust, but if it blocks operators or requires too much ritual, it becomes an obstacle. RedlineSpec must prioritize simple, composable, and versatile tools that make it possible to decide, evaluate, and implement functionality without turning the process into bureaucracy.

Simplicity does not mean lack of rigor. It means rigor must be concentrated where it provides the most value: clear contracts, traceable decisions, verifiable criteria, and alignment between what was promised and what was implemented.

## 5. Signatures as technical contracts

A cross-cutting RedlineSpec concept is that many pieces of software can be understood through their signature.

A class, component, module, service, endpoint, or function exposes a form of interaction: inputs, outputs, public methods, events, expected effects, errors, invariants, and relevant dependencies. That signature is easier to understand than the full internal complexity of the implementation.

RedlineSpec must use this idea in technical plans. More capable agents can define clear technical signatures so less capable agents can implement while respecting those boundaries. Instead of asking an agent to infer the entire architecture from scratch, the technical plan should give it concrete contracts that reduce ambiguity.

A technical signature can describe, for example:

- Which module, class, component, or endpoint must exist.
- Which inputs it accepts.
- Which outputs it produces.
- Which errors or states it must handle.
- Which invariants it must not break.
- Which dependencies it may use.
- Which behavior is out of scope.

This brings AI development closer to the way a human developer understands unfamiliar code: first identifying interfaces and responsibilities, then entering internal details only when necessary.

## 6. Contracts reinforced by tests

Contracts must be verifiable.

If a signature defines the expected behavior of a piece of software, that signature can be reinforced with tests. RedlineSpec should favor an approach close to TDD when useful: first establish the observable contract, then implement until it is satisfied.

Tests must not validate accidental implementation details. They must protect the relevant agreements: inputs, outputs, errors, invariants, and expected behavior. In this way, contracts stop being only documentation and become control mechanisms.

## 7. Guiding principles

RedlineSpec must evolve according to these principles:

- Contract-first: every important phase must produce RedlineSpec contracts usable by the next one.
- Method-agnostic: how the information is obtained does not matter; what matters is that it is delivered in a standardized form.
- Single source of truth: specs must not compete with the consolidated functional truth or with the code.
- Functional merge: when development closes, the functional truth must be updated to reflect what was actually implemented.
- Simplicity over ritual: the framework must enable decisions and implementations, not impose bureaucracy.
- Signatures before internals: technical plans must prioritize interfaces, responsibilities, and verifiable boundaries.
- Verifiability: every important contract should be checkable through review, tests, or both.
- Suitable for uneven agents: the framework must allow powerful agents to define contracts that less powerful agents can follow.
