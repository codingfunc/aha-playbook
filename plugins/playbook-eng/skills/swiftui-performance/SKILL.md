---
name: swiftui-performance
description: Use when diagnosing SwiftUI scrolling hitches, slow updates, hangs, or CPU and memory problems, or validating a SwiftUI performance change
---

# SwiftUI performance

Use [swiftui-architecture](../swiftui-architecture/SKILL.md) for architectural
conventions. Keep performance work scoped to the reported interaction and
preserve observable behavior. Existing engineering review gates still apply.

## Establish the symptom

Record the affected flow, reproduction steps, data volume, device or
simulator, OS, and build configuration. Use available project evidence
first; request missing information only when it affects the diagnosis.
Agree on the relevant metric from the symptom, without inventing a budget.

## Inspect likely causes

- Expensive sorting, filtering, formatting, I/O, or image decoding in view
  initialization or `body`, especially during scrolling.
- Unstable list identities or structural changes that repeatedly recreate
  state and platform views.
- Broad observation dependencies that cause unrelated views to update.
- Geometry or preference feedback that repeatedly changes layout inputs.
- Oversized images, retained tasks, or caches without an ownership and
  invalidation policy.

Treat these as hypotheses until evidence connects them to the symptom.
Extracting a view, adding a lazy container, or moving work to an async
function does not by itself establish a performance improvement.

## Measure and change

Use the [profiling workflow](references/profiling.md) when runtime evidence
is needed or when validating a performance claim. Separate the time spent
in each update from how often updates occur; they require different fixes.

Choose the smallest change supported by the evidence. Derived-state caches
need explicit invalidation and memory costs. Equality shortcuts must include
every input affecting the result and cost less than the work they avoid.
Background work needs an explicit isolation and cancellation plan.

## Report

Give the affected location, evidence, likely cause, proposed or implemented
fix, and remaining uncertainty. Compare before and after only for equivalent
captures. If profiling was unavailable, report a code-level hypothesis and
the missing measurement, not a claimed speedup.

## Sources

- [Apple: Understanding and improving SwiftUI performance](https://developer.apple.com/documentation/xcode/understanding-and-improving-swiftui-performance)
- [Apple: Demystify SwiftUI performance](https://developer.apple.com/videos/play/wwdc2023/10160/)
- Further reading: [Thomas Ricouard's SwiftUI Performance Audit](https://github.com/Dimillian/Skills/tree/main/swiftui-performance-audit)
