---
name: modular-design
description: Use when designing a new component, module, or system boundary - keeps units small, abstract, and robust to future change
---

# Modular design

Design for modularity and abstraction. Ask what is likely to change, and put
a boundary there.

## Test for a good unit

For each unit you should be able to answer three questions:

1. What does it do?
2. How do you use it?
3. What does it depend on?

If someone cannot understand what a unit does without reading its internals,
the boundary is wrong. If you cannot change the internals without breaking
consumers, the interface is wrong.

## Expandability

Before settling on a design, ask what the next three plausible requirements
are, and check that none of them forces a rewrite of the interface. Design
robust to change — not for imagined features, but so that adding them later
does not mean tearing the seams open.

Do not build the imagined features. YAGNI applies to code; this principle
applies only to where the seams go.

## File size as a signal

When a file grows large, that usually means it is doing too much. Files that
change together belong together; split by responsibility, not by technical
layer.
