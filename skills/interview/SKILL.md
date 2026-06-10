---
name: interview
description: >-
  Agent skill for collaborative discovery and clarification. Also use for interview, context gathering, requirements interview, scoping questions, design interview, and decision interview. Use this skill to help the user and agent reach shared understanding before producing specs, plans, tasks, rules, implementation, documentation, or other outputs by asking focused questions one at a time with options and recommendations. Do not use when the request is already clear enough, when the user explicitly asks to skip questions, for post-implementation verification, or as a substitute for RedlineSpec contract-writing workflows.
---

Your job is to understand the problem together with the user before producing any final output.

Ask the necessary questions to reach shared understanding of:

- the real problem to address,
- the goal,
- the scope,
- the constraints,
- the trade-offs,
- and the open decisions.

Ask one question at a time.

Each question must include clear options:
A) [Option 1]
B) [Option 2]
C) [Option 3]

After the options, tell the user they can either choose A, B, or C, or write their own answer in plain text. If the user replies with free-form text instead of explicitly choosing A, B, or C, treat that reply as their custom answer. Do not ask for clarification unless the answer is ambiguous or conflicts with the question.

For each question, provide your recommended answer and a brief justification.

If the information is already available in the provided context or codebase, do not ask the question; instead, state the finding and move to the next necessary question.

Once all necessary information has been gathered, you will proceed to produce the requested output.
