---
name: domain-modeling
description: Use when defining or reconciling project domain terminology, maintaining a domain glossary, or recording a consequential architectural decision
---

# Domain modeling

Sharpen the project's domain language and preserve decisions whose reasons
would otherwise be lost. Merely reading an existing glossary does not
require a modeling session.

## Find the existing model

Follow the repository's glossary and ADR conventions. If `CONTEXT-MAP.md`
exists, use it to locate the relevant context; otherwise look for a root
`CONTEXT.md`. Read applicable ADRs before proposing a conflicting decision.
Ask if the relevant context is ambiguous. Do not introduce multiple contexts
just because the repository has multiple packages.

## Resolve terminology

- Surface conflicts between a term's existing definition and its current use.
- Separate overloaded concepts and propose precise canonical names.
- Use concrete hypothetical scenarios to clarify relationships and ownership.
  Label them as questions to resolve, not newly established business rules.
- Check relevant code against the claimed behavior. Present contradictions
  for resolution rather than treating either code or conversation as
  automatically authoritative.

Keep unresolved terms visible in the discussion. Record only agreed meanings.
The glossary describes domain concepts and relationships; implementation
plans and architecture decisions belong elsewhere.

## Preserve agreed decisions

Use [document formats](references/document-formats.md) when preparing a
glossary entry or ADR. Existing repository formats take precedence.

Offer an ADR when the decision is costly to reverse, its reasoning would
surprise a future reader, and real alternatives were considered. Capture
the decision and the reason, including a rejected alternative only when
that rejection is useful context.

Draft the proposed document changes in chat and obtain approval before
writing, following the core working agreement. Create a glossary or ADR
directory only when approved content needs it. Batch agreed changes into
that approved write instead of editing documents throughout the discussion.

Adapted from Matt Pocock's `domain-modeling`; see [attribution](../../THIRD_PARTY_NOTICES.md).
