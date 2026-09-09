---
name: code-quality
description: Use when writing or reviewing any production code - the baseline quality bar covering error handling, SOLID principles, single source of truth, type safety, and ACID database design
---

# Code quality

All proposed code is clean, modular, and includes basic error handling.

## Design principles

Follow the coding best practices and design patterns of the language in use.

- **Single responsibility** — a unit does one thing.
- **Open/closed** — open for extension, closed for modification.
- **Liskov substitution** — a subtype is usable anywhere its base type is.
- **Interface segregation** — many focused interfaces beat one broad one.
- **Dependency inversion** — depend on abstractions, not concretions.

## Single source of truth

Define each fact once and derive everything else from it. Field
descriptions, validation rules, and documentation live in one place — the
schema or model — never duplicated by hand elsewhere.

## Type safety

Static type checking is on at its strictest setting and passes clean. No
suppressions or `Any` escapes without a comment stating why the checker
cannot express the type.

## Database design

Design for ACID: atomicity, consistency, isolation, durability. State which
of these a schema or transaction boundary is relying on when it is not
obvious.

## Error handling

Handle the errors the code can actually encounter. Do not add speculative
handling for conditions that cannot arise — that is noise, and it hides the
paths that matter.
