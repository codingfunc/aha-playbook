---
name: quality-check
description: Use when asked to review the current uncommitted diff against the playbook engineering quality checklist; report findings without changing files
---

Review the current uncommitted diff against the playbook quality bar. Read
the [code-quality](../code-quality/SKILL.md),
[refactoring-discipline](../refactoring-discipline/SKILL.md),
[code-comments](../code-comments/SKILL.md), and
[testing-standards](../testing-standards/SKILL.md) skills first, then apply them.

Run `git diff` and `git diff --staged` to see the changes. If both are empty,
say so and stop.

Report findings under these four headings, and only report a heading if it
has findings:

1. **Quality** — error handling that is missing or speculative, SOLID
   violations, invented values that the spec never stated.
2. **Scope** — changes to adjacent code, comments, or formatting that the
   task did not require; refactoring of things that were not broken; deleted
   pre-existing dead code.
3. **Comments** — narration of what the code does, restated history, or a
   public Dart API left undocumented.
4. **Tests** — a mocked service class where only the low-level client should
   be mocked; tests written before the implementation review.

For each finding give the file, the line, and one sentence on why it matters.
Do not fix anything. Report, then stop.

If the diff is clean against all four, say so in one sentence.
