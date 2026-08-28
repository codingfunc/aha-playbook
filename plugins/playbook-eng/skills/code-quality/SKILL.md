---
name: code-quality
description: Use when writing or reviewing any production code - the baseline quality bar covering error handling, SOLID principles, and ACID database design
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

## Database design

Design for ACID: atomicity, consistency, isolation, durability. State which
of these a schema or transaction boundary is relying on when it is not
obvious.

## Error handling

Handle the errors the code can actually encounter. Do not add speculative
handling for conditions that cannot arise — that is noise, and it hides the
paths that matter.

Never invent a threshold, retry count, timeout, or backoff value. If the spec
does not state it, stop and ask.
