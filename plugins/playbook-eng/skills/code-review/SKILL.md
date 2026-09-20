---
name: code-review
description: Use when asked to review committed branch or PR changes against a base and an originating spec - reports standards and requirement findings separately without editing files
---

# Code review

Review committed changes along two independent axes: conformance to the
project's standards and fidelity to the originating requirements. For only
staged or unstaged changes, use [quality-check](../quality-check/SKILL.md).

## Establish the review scope

Use the base and head identified by the user or PR. Ask when the intended
comparison is unclear. Resolve both refs to commit IDs and record them so
the review remains tied to a fixed snapshot.

For a branch or PR review, compare the merge-base to the head with
`git diff <base>...<head>` and inspect `git log <base>..<head> --oneline`.
If the user requests two exact snapshots, use a two-endpoint diff instead
and state that choice. Validate refs before reading the diff. Report an
empty diff and stop. Identify uncommitted work as outside this comparison.

Locate the spec from a supplied reference, linked issue, commit message,
or relevant repository document. Read requirements and clarifying comments.
If the source is unclear, ask; if none exists, perform standards review
and explicitly mark requirements as unassessed. No tracker setup is required.

## Review standards

Read the repository's applicable instructions and standards, including
[code-quality](../code-quality/SKILL.md),
[refactoring-discipline](../refactoring-discipline/SKILL.md),
[code-comments](../code-comments/SKILL.md), and
[testing-standards](../testing-standards/SKILL.md). Consult language, security,
and design skills when relevant to the changed behavior.

Inspect surrounding code and callers as needed to assess the diff. Cite
the rule for a standards violation. Distinguish documented violations from
design concerns such as duplicated logic, scattered responsibility, or
speculative abstractions; a smell alone is not a defect. Explain a concrete
consequence and suppress concerns contradicted by project conventions.

## Review requirements

For each requirement, trace the changed behavior and relevant evidence.
Look for missing or partial behavior, implementation that contradicts the
requirement, and additions outside the requested scope. Cite the specific
requirement for each finding. Code that looks plausible is not proof that
the behavior has been tested; state gaps in verification explicitly.

## Report

Keep **Standards** and **Requirements** findings separate so success on one
axis cannot conceal a failure on the other. For each finding include the
file and line, impact, supporting rule or requirement, and why it matters.
Report uncertainty as uncertainty. State when an axis has no findings or
could not be assessed, and name any checks actually run.

Report findings without modifying files, publishing comments, or committing.
The review does not itself authorize fixes.

Adapted from Matt Pocock's `code-review`; see [attribution](../../THIRD_PARTY_NOTICES.md).
