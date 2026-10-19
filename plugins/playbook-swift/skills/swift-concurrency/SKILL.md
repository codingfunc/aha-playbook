---
name: swift-concurrency
description: Use when implementing or reviewing Swift async code, actor isolation, cancellation, task lifetimes, or strict-concurrency diagnostics
---

# Swift concurrency

Use alongside [swift-conventions](../swift-conventions/SKILL.md). Inspect the
installed Swift toolchain, language mode, default actor isolation, and
concurrency feature settings in each affected target before choosing a fix.
Do not change deployment targets or build settings just to fit an example.

## Isolation and reentrancy

- Identify the state being protected and its isolation boundary. An actor
  prevents unsynchronized access; it does not make an entire async method
  atomic.
- At each suspension point, check whether later work relies on state read
  earlier. Other actor calls may have changed it while this call suspended.
  Revalidate the invariant or explicitly model the operation's state.
- A cache miss followed by an awaited fetch can duplicate work. If callers
  must share a request, track in-flight work and define failure, cancellation,
  and invalidation behavior. Returning a local result alone is not deduplication.
- Check values crossing isolation boundaries. Do not silence a diagnostic
  with `@unchecked Sendable`, `nonisolated(unsafe)`, or `@preconcurrency` as a
  substitute for explaining the actual synchronization or interop boundary.
- `async` does not establish a background execution context. Check executor
  behavior before putting CPU-heavy work in UI-facing async methods.

## Task ownership

- Prefer `async let` for a fixed set of child operations and task groups for
  dynamic child work when the parent must await completion.
- For every unstructured `Task`, identify who owns its lifetime, observes
  errors, and cancels it. `Task.detached` is not a general performance fix;
  inspect isolation and inherited context before using it.
- Bound concurrent work using the project's workload and resource limits.
  Ask for an unstated limit rather than inventing one.
- A cancellation request is cooperative. Check cancellation at useful work
  boundaries; do not turn cancellation into a success, user-facing failure,
  or automatic retry unless that is the intended contract.
- In SwiftUI, prefer lifecycle-managed `.task` or `.task(id:)` for view-owned
  async work. Cancellation still needs cooperation from the underlying work.

For callback adapters, streams, or cancellation cleanup, read
[boundary guidance](references/boundaries.md).

## Review and validation

Trace one operation from its owner through suspension, completion, error,
and cancellation. Report the concrete interleaving or lifetime problem,
its location, and the smallest fix; do not report a pattern match as a bug.
Validate with the affected target's compiler settings. Follow
[testing-standards](../testing-standards/SKILL.md) and existing review gates
when tests are authorized; synchronize tests on events rather than sleeps.

## Sources

- [Swift concurrency migration guide](https://www.swift.org/migration/documentation/swift-6-concurrency-migration-guide/)
- [Swift actor semantics](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0306-actors.md)
- Further reading: [Paul Hudson's Swift Concurrency Pro](https://github.com/twostraws/Swift-Concurrency-Agent-Skill)
