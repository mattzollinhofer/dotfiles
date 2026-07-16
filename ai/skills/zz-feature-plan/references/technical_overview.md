# Developer-oriented technical overview

Use this reference when researching and writing the technical overview for a
feature plan. The overview is an onboarding aid for a developer who knows the
project's language and framework but is new to this product area and its code.
It should help that developer understand and evaluate the proposed plan, not
just execute a list of file edits.

## What the overview should teach

Build a bounded overview of the subsystem relevant to the feature. Explain:

- the product problem the feature area solves and the people or workflows it
  serves
- project-specific domain terms and important distinctions between nearby
  concepts
- the principal records and relationships involved
- the current end-to-end behavior, including where data enters, how it is
  transformed or acted upon, and what users ultimately observe
- the major components and the responsibilities they own
- relevant permissions, background work, integrations, side effects, or
  operational concerns
- how existing tests express the important behavior
- non-obvious conventions, constraints, risky seams, and historical context
  when that history is supported by tickets, comments, code, or repository
  history
- where the requested feature intersects established behavior and ownership
  boundaries
- a suggested reading order for the most useful files

Scale the depth to the task. A small change may need only a compact orientation;
a feature touching an unfamiliar subsystem may need a substantial explanation.
Do not expand into an overview of the entire application.

## How to research it

Do not infer the overview from filenames alone. Read the important production
paths, representative tests, domain models, policies, forms or services,
controllers and views, jobs, and integration boundaries that participate in the
behavior. Trace at least one representative workflow end to end. Use repository
history only when it clarifies a meaningful design seam or product concept; do
not invent historical rationale from code shape.

Personally verify the central claims after any sub-agent exploration. Cite file
paths where they help the reader continue learning.

## How to write it

Prefer a coherent teaching narrative over a directory listing. Introduce the
product purpose and vocabulary before explaining the technical flow. Explain
why a component matters and what responsibility it owns, not merely that the
file exists.

Use useful subsections such as:

- Feature-space overview
- User workflows and domain language
- Current end-to-end behavior
- Components and responsibility boundaries
- Data, permissions, integrations, and side effects
- Tests and non-obvious constraints
- How the requested feature fits
- Suggested reading order

Adapt these headings rather than mechanically including empty or repetitive
sections.

Clearly distinguish:

- established current behavior verified from evidence or code
- likely insertion points suggested by existing ownership
- possible implementation choices that remain open

Do not turn likely files into required implementation shape. Do not invent new
classes, method signatures, APIs, or call graphs merely to make the explanation
feel concrete.

## Diagrams

Diagrams support the overview; they are not its organizing purpose. For most
nontrivial feature areas, include one to three focused Mermaid diagrams when
visual review would improve understanding. A diagram may intentionally repeat
nearby prose because the second representation can expose missing transitions
or unclear boundaries.

Useful subjects include the bounded feature-area relationships, current
request or data flow, and the requested feature's intersection with established
owners. Keep diagrams narrow, label current and proposed behavior distinctly,
and avoid diagramming the whole application or presenting speculative design as
fact.

Place Mermaid notation directly in `draft-plan.md` so the draft is the shared
textual and visual review surface. Do not create separate `.mmd`, PNG, or SVG
artifacts by default.

## Quality check

A useful overview should let a newer developer answer:

1. What does this area do for users?
2. What vocabulary does the team use for it?
3. How does the relevant behavior work today?
4. Which existing components own each responsibility, and why?
5. What constraints or surprises could affect the change?
6. Where does this feature fit without prematurely prescribing its design?
7. Which files should I read next to deepen my understanding?

If the overview answers only "which files will change?", it is not sufficient.
