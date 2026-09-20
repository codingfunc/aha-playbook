---
name: verified-documentation
description: Use when writing or updating a document that describes the code - architecture overviews, module tables, documented signatures - so the document is enforced by a test rather than trusted
---

# Verified documentation

A document that describes the code drifts the moment the code moves. Prose
cannot be trusted to stay true. A test can.

## The rule

Any document that names symbols — modules, entry points, signatures, schema
fields — is covered by a test that resolves every symbol it names. The
document then fails the build when it goes stale, exactly as code does.

## Parse, do not restate

The test reads the document and derives its expectations from it. It never
holds a second copy of the list.

A test that restates the document is a second source of truth: it drifts on
its own, and a row added to the document silently escapes coverage. A test
that parses the document extends its own coverage as the document grows.

## What earns this

- Architecture and module overviews that a contributor or an agent reads
  before the code.
- Documented signatures and call contracts.
- Schema and enum tables that something else consumes.

Not rationale, narrative, or changelogs. Those describe decisions, not
structure, and have no symbol to resolve.

## Record what the drift cost

When the test is added because a document had already gone stale, say in its
docstring what the stale document caused. A wrong document is worse than a
missing one: someone followed it and wrote code that ran.
