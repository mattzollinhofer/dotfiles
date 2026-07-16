---
description:
  Plan a feature with gated discovery, domain alignment, and TDD tasks
argument-hint: "<request / Shortcut URL / Figma URL / notes>"
---

## User request

$ARGUMENTS

Treat this request as the primary planning goal. If it includes a Shortcut URL,
Figma URL, spreadsheet URL, evidence, acceptance criteria, or feedback notes,
incorporate those details explicitly. Do not plan only from the branch name or
from existing code.

This command is for planning only. Do not implement the feature. Do not create
`plan.md` until the feature-understanding checkpoint, including proposed
commit/test staging, has been approved.

## Stage 1: Gather all product and design evidence

Build a complete picture of the requested feature before planning tests or
implementation.

1. Read the user request carefully and extract:
   - the user-facing problem or desired outcome
   - every stated acceptance criterion
   - any explicit non-goals, constraints, or stakeholder comments
   - links to Shortcut, Figma, spreadsheets, screenshots, logs, or other
     evidence
2. If a Shortcut URL is provided, fetch and read the story description,
   acceptance criteria, comments, tasks, attachments, and linked resources.
3. If Figma URLs are provided, download **all** referenced Figma images and use
   them as product evidence. Do not ignore secondary Figma links. Store the
   downloaded Figma `.png` and matching `.json` files in a repo-local temporary
   directory named for the Shortcut story when available, such as
   `tmp/sc-12342-figma/`. If there is no Shortcut story number, use a concise
   task-based name under `tmp/`, such as `tmp/message-template-figma/`. Commit
   the downloaded Figma evidence separately with
   `git add tmp/<figma-dir> && git commit -m 'temp: figma'` before continuing
   the plan.
4. If spreadsheet, screenshot, log, or other evidence is provided, inspect the
   relevant parts and summarize what they prove.
5. Note any conflict between sources instead of smoothing it over.

## Stage 2: Explore and reflect on the codebase

Before proposing tests, understand how the feature should fit into the existing
implementation.

Use the `Task` tool to launch an `explore` sub-agent to search for relevant
files. Instruct the sub-agent to thoroughly read the implementation, related
tests, nearby patterns, and existing abstractions that should influence the
plan. The sub-agent should return a concise summary of:

- relevant file paths and what they do
- likely production files that will need changes
- existing test files or test patterns that should be followed
- default framework or existing product behavior that may already satisfy parts
  of the request
- important constraints, ambiguities, architectural considerations, or risky
  seams
- overloaded or fuzzy domain terms that should be clarified before planning
- existing WelcomeHome guidelines or review-plan guidance that should shape the
  implementation

After the sub-agent returns, personally read the most important files yourself.
Do not outsource the feature interpretation entirely to the sub-agent. Reflect
on how the requested behavior fits the current architecture and where the code
suggests a simpler or more cohesive product shape.

For WelcomeHome work, challenge the request against the existing WelcomeHome
language and durable guidance, and apply that guidance while planning. Do not
propose or add a task to update the WelcomeHome guidelines repository/skill
unless the user explicitly requests that documentation work.

## Stage 3: Resolve ambiguities before the feature-understanding checkpoint

Before presenting a feature-understanding checkpoint, stop and ask any blocking
product or technical questions. Do not bundle questions with the full
understanding checkpoint; get the answers first, then revise the understanding
around those answers.

Interview the user until you reach a shared understanding. Walk down each branch
of the design tree, resolving dependencies between decisions one-by-one. For
each question, provide your recommended answer. If a question can be answered by
exploring the codebase, explore the codebase instead of asking.

Ask about missing behavior, contradictory evidence, unclear edge cases,
permissions, copy, ordering, empty states, error states, data migration
expectations, rollout concerns, or acceptance criteria that cannot be planned
without a product decision.

If anything is ambiguous, present only:

- **Questions that need answers before planning**: concise, specific questions
  with enough context for the user to answer them
- **Why each answer matters**: the implementation, test, or scope decision the
  answer will affect

Wait for the user's answers before continuing. Do not invent product decisions.
After the user answers, revisit the evidence and code reality before presenting
the feature-understanding checkpoint.

If nothing is ambiguous, say that no blocking questions came up and proceed to
the feature-understanding checkpoint.

The feature-understanding checkpoint should be concise but explicit. Include:

- **Evidence reviewed**: ticket, comments, Figma images, screenshots,
  spreadsheets, existing code, and tests that shaped your understanding
- **Cohesive feature thesis**: what the ticket is really asking for in product
  terms, not just a list of requested changes
- **Code reality**: how the current implementation behaves and where the new
  behavior likely belongs
- **Domain language and design boundaries**: the ubiquitous terms the
  implementation should use, overloaded or fuzzy terms to avoid, conflicts with
  existing WelcomeHome language, established architectural facts, existing
  behavior owners or execution seams to reuse, and the conceptual responsibility
  boundaries the implementation should preserve. Distinguish existing codebase
  interfaces from proposed new design: name established classes or methods when
  they are relevant facts, but describe new collaborators and APIs by
  responsibility rather than inventing class names, method names, signatures, or
  call graphs.
- **Acceptance-criteria review**:
  - criteria that describe meaningful observable outcomes
  - criteria that appear to be over-specified, redundant, or merely default
    framework/browser/product behavior
  - criteria that should be removed, rewritten, or treated as non-goals so they
    do not confuse the implementation plan
- **Proposed commit staging**: the likely commits or independently reviewable
  slices, formatted like a small commit stack with the test plan merged into
  each proposed commit. Each proposed commit should use a fully bolded
  commit-title line, an optional `[DEV]` prefix only for behavior-preserving
  internal prep, and a short 2-3 sentence commit-body-style paragraph. Do not
  label user-facing commits; an unprefixed title means it changes product
  behavior. After the paragraph, include concise test notes naming the proposed
  test level/file, why that coverage is enough, and what not to test or
  implement in that slice. Use this shape:

  ```markdown
  **[DEV] Prepare the internal seam**

  Refactor the existing path so the later product behavior can use one clear
  interface. Current user-visible behavior should stay the same.

  Tests: run the existing focused coverage that protects this behavior, such as
  `test/path/example_test.rb`. Do not add new characterization coverage unless
  exploration shows the refactor lacks meaningful existing coverage, and do not
  add the new product behavior in this commit.

  **Add the user-facing behavior**

  Describe what changes for users and why this is a useful reviewable slice.
  Note any important scope limit for this commit.

  Tests: add or augment `test/path/example_test.rb` with the smallest RED test
  that proves the behavior. Do not cover later variants or default framework
  behavior here.
  ```

- **Proposed rewritten ticket description** when it would make the work clearer

Ask the user to confirm the cohesive feature thesis, domain language and design
boundaries, proposed commit/test staging, and any acceptance-criteria cleanup
before moving on. Proceed only after the user confirms or corrects the
understanding.

## Stage 4: Test-planning rules for proposed commits

Use these rules when preparing the proposed commit/test staging in the
feature-understanding checkpoint and when writing `plan.md`. Do not present a
separate test-strategy gate after the user confirms the feature understanding;
the test plan should already be visible inside the proposed commit staging.

Think of testing as "test golf" -- maximize confidence with the fewest tests:

- Unit/model test = 1 stroke
- Controller/view/request test = 3 strokes
- System test = 5 strokes

A system test is worthwhile when it efficiently verifies the full stack: the
user can reach the UI, inputs are wired through the controller, data persists,
and the result is visible. Prefer lower-level tests for branching logic,
permissions, formatting, validation edge cases, or pure domain behavior.

Follow these testing principles:

- Assert business behavior, not implementation details.
- Avoid stubs/mocks except for external services isolated behind Client classes.
- Do not test configuration, static i18n keys, or non-logic view markup unless
  the ticket specifically changes observable behavior there.
- Do not add multiple system tests for small variants when one system test plus
  focused unit tests would cover the behavior better.
- Tests should be straight linear arrange/act/assert code with no conditionals
  or loops.
- If nuanced behavior seems testable only through a slow or brittle high-level
  test, treat that as a design smell and consider a refactor that exposes the
  logic at a lower level.

For larger features, chunk the work by product behavior before choosing tests:

- When a behavior-preserving architecture or interface change would make the
  feature smaller or clearer, prefer planning it as a separate **[DEV]** slice
  before the user-facing slice.
- A **[DEV]** slice should preserve current behavior and normally be validated
  by existing green coverage. Add narrow characterization coverage only when the
  refactor would otherwise be unprotected.
- Identify the smallest product-visible core behavior that would be useful or
  reviewable on its own.
- Then identify layers of complexity that can be added later, such as editing,
  deletion, grouping, ordering, permissions, edge states, bulk behavior,
  advanced UI interactions, or polish.
- Prefer a simple initial implementation that supports the current stage over a
  fully generalized design for all later stages.
- Each stage should leave the product non-broken and should be independently
  reviewable by product and code reviewers.
- Make explicit what each stage does **not** implement yet, so later complexity
  does not leak into the first task.
- Never split by technical layers such as "backend, then frontend". Split by
  slices of functionality that users can observe.

For each proposed commit, include test notes with:

- proposed test level and file, or existing test command/file for pure `[DEV]`
  refactors
- why that level is appropriate
- what not to test or implement yet because it belongs to a later commit, is
  default behavior, is already covered, or is out of scope

Do not write `plan.md` until the user has approved the feature-understanding
checkpoint that includes the proposed commit/test staging.

## Stage 5: Generate `plan.md`

Using the approved feature understanding and proposed commit/test staging,
generate a `plan.md` file.

The file should contain these sections, in this order:

1. **Spec**: A high-level overview of the finished task from the end-user or
   product perspective. Keep this to 1-3 paragraphs. If helpful, use the
   rewritten ticket description approved in the feature-understanding
   checkpoint.
2. **Decisions and Scope**: Clarifications, acceptance-criteria cleanup,
   explicit non-goals, and product decisions made during the checkpoint.
3. **Commit Plan**: The approved commit/test staging, formatted as a checklist
   of commit-worthy slices. Each top-level checkbox must be exactly one complete
   commit slice: either a behavior-preserving `[DEV]` refactor or a
   product-visible feature slice. Do not create top-level checkboxes that only
   add tests, only make tests red, only implement production code for a previous
   test, or split work by technical layer such as backend/frontend. Test-only
   and implementation-only steps may appear only as nested bullets inside the
   same product-visible checkbox.
4. **Domain Language and Design Boundaries**: The approved ubiquitous language,
   important distinctions between nearby concepts, established codebase seams
   and behavior owners, and responsibility boundaries. Describe new design by
   responsibilities and constraints rather than prescribing new classes,
   methods, signatures, or call graphs. Make clear that likely production files
   and possible collaborators are starting points, not required implementation
   shape.
5. **Plan**: The implementation approach in 1-3 paragraphs.
6. **Post-Implementation Verification**: A concise WHS review and final manual
   QA sequence that follows the requirements below.
7. **Context**: Relevant file paths and what they are responsible for.

Plans should constrain product behavior and established responsibility
boundaries, not freeze speculative implementation shape. Do not present a new
class or method signature for user approval unless establishing that exact
interface is itself an explicit requirement. If a RED test or closer code
reading reveals a more natural design, the implementation should deviate from
likely files or collaborators without requiring a plan amendment, as long as it
preserves approved behavior, scope, existing ownership constraints, and commit
boundaries.

### Commit Plan slice requirements

Keep top-level checkboxes sacred: every top-level checkbox should become one
cohesive commit unless explicitly corrected during implementation. Backend-only
slices are fine, but do not add a UI entry point, link, or button until it leads
to working behavior. For larger features, order checkboxes by the approved
behavior stages: start with the smallest useful core behavior, then add one
layer of complexity at a time. Do not make an early checkbox carry hidden
requirements for a later stage.

Each top-level checkbox should include:

- a fully bolded commit-title line, using an optional `[DEV]` prefix only for
  behavior-preserving internal prep; do not label user-facing commits because an
  unprefixed title means it changes product behavior
- a short 2-3 sentence commit-body-style paragraph explaining the behavior or
  architecture change it owns
- whether the slice maps to a `[DEV]` proposed commit or product-visible
  proposed commit
- for `[DEV]` slices, the internal design or architecture change, the
  user-visible behavior that must remain unchanged, and the existing green
  coverage that protects it by default; add new characterization coverage only
  when the refactor would otherwise be unprotected
- for product-visible slices, the full strict-TDD loop inside the same checkbox:
  check whether an existing test already covers the same acceptance criterion;
  add or augment the smallest RED test in the named test file and scenario;
  confirm the test is RED before production changes; implement the smallest
  production change to make it pass; and confirm the relevant tests are GREEN
- production files likely to change, listed after the RED-test steps so the plan
  reinforces TDD ordering and labeled as starting points rather than an
  exhaustive or required implementation shape
- the behavioral boundary, established owner, or architectural constraint from
  the approved Domain Language and Design Boundaries section that this slice is
  expected to preserve, without requiring a speculative new API shape
- a nested reminder to extract new user-facing strings to i18n when the slice
  adds copy, reusing existing keys when the same string and concept already
  exist
- a nested reminder to commit the complete GREEN slice

Do not add new product behavior in a `[DEV]` checkbox. Do not include
add/augment test bullets for product-visible work unless the test should go red
before the production change. If an existing test already covers an acceptance
criterion and is green, do not plan a redundant new test or add extra assertions
to that test. If a proposed new or augmented test is green before
implementation, remove or revert that test change instead of keeping it as
acceptance or regression coverage. If an existing test is already RED before any
changes, treat that failing test as the RED driver for the current
product-visible checkbox; do not add redundant test-only coverage or create a
separate test commit.

### Post-Implementation Verification requirements

Every generated plan should end implementation with a concise
**Post-Implementation Verification** section containing these steps in order:

1. For WelcomeHome work, run the WHS review after implementation. Address
   concrete review findings in separate commits titled `fixup: <summary>`. In
   each commit body, include the review feedback that prompted the change and
   explain what the commit changes in response. Do not amend the implementation
   commits, use `fixup!` or `git commit --fixup`, autosquash, or otherwise
   squash review-driven changes; leave every `fixup:` commit visible for human
   judgment.
2. Perform manual QA at the very end, after review-driven changes. Address any
   concrete issues it reveals, using the same visible `fixup: <summary>` commit
   policy for QA-driven changes.
3. Arrange the final history so every review- or QA-driven fixup appears
   immediately after the implementation commit it belongs to. Each fixup must
   have exactly one target; split cross-cutting fixes as needed. Preserve
   dependency order between fixups, resolve all conflicts, and rerun affected
   tests and final branch checks. Keep every fixup visible: do not amend,
   squash, or autosquash it. Choose the safest Git workflow for producing that
   final history.

Do not expand manual QA into a detailed script, tool prescription, workflow,
scenario list, or expected-outcome essay unless the user explicitly asks for
that detail. Post-implementation verification is not a top-level Commit Plan
checkbox and should not use Markdown task-list checkboxes.

## Stage 6: Commit the plan draft

Commit the plan with:

```sh
git add plan.md && git commit -m 'temp: plan.md'
```
