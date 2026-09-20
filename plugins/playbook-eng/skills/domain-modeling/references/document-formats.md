# Domain document formats

Follow existing repository conventions. Where none exist, use these small
Markdown formats after the proposed content is approved.

## Glossary

Use `CONTEXT.md` at the repository root for a single context. If an existing
`CONTEXT-MAP.md` points to multiple contexts, place terms in the appropriate
context's glossary.

```markdown
# Ordering

Domain language for placing and fulfilling orders.

## Language

**Order**: A customer's accepted request for a set of items.
_Avoid_: Purchase, transaction.
```

Define each concept briefly using the agreed language. Include aliases to
avoid only where they cause confusion. Add relationships when needed to
disambiguate concepts. Keep general programming terminology, implementation
details, and unresolved proposals out of the glossary.

## Architecture decision record

Default to `docs/adr/NNNN-short-title.md`. Inspect existing filenames and use
the next available number; in a multi-context repository, use its established
location for context-specific or system-wide decisions.

```markdown
# Short decision title

State the context, the agreed decision, and the reason in a short paragraph.
```

Add alternatives, consequences, or status only when they explain something
non-obvious. When revisiting a decision, preserve the original rationale and
link the superseding decision according to the repository's convention.
