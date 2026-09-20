---
name: generated-artifacts
description: Use when code, documentation, or configuration is produced by a generator - the check, baseline, and regeneration workflow that stops a generated file being hand-edited
---

# Generated artifacts

A generated file has one author: the generator. A hand edit to it is a defect
that survives only until the next regeneration silently reverts it.

## The check

Every generator ships a check mode that regenerates into memory and compares
against what is committed. It runs in the pre-commit hook and again in CI, so
a hand edit fails locally and in review with the same message.

A generator without a check is a suggestion.

## The baseline

Expected output is committed beside the generator, not computed at review
time. Regeneration is an explicit separate action — a bless flag or
equivalent — so accepting a diff is a decision someone made, never a side
effect of running the tests.

## Validate the structure, not only the bytes

A byte comparison catches a hand edit. It does not catch a generator emitting
well-formed, wrong output. Where the generated set has invariants — every
target covered, an enum defined once, a transform that round-trips — each
invariant gets its own check beside the byte comparison, named for what it
guards.

## Reading one back

Do not read a generated artifact back to confirm the generator worked; the
check is what confirms it. The working agreement stands: read one only when
it has failed.
