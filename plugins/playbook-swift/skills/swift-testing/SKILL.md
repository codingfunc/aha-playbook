---
name: swift-testing
description: Use when writing or reviewing Swift unit and integration tests, async test synchronization, parameterized tests, or XCTest migrations
---

# Swift testing

Apply [testing-standards](../testing-standards/SKILL.md) and the engineering
working agreement. This skill describes test mechanics; it does not change
implementation-review gates, expected behavior, or mocking policy.

Use Swift Testing for new unit and integration tests where supported by the
project's toolchain. UI automation remains in XCTest/XCUITest. Keep existing
XCTest tests unless migration is part of the task; both frameworks can
coexist in a test target without mixing their assertions within one test.

## Assertions and cases

- Use `#expect` for a check that permits the test to continue. Use throwing
  `#require` when subsequent steps depend on a condition or unwrapped value.
  Avoid force-unwrapping after a non-fatal expectation.
- Assert specified behavior and meaningful error identity or payload. A test
  that accepts any thrown error may pass for the wrong reason.
- Parameterize cases that share one behavioral contract. Keep distinct
  setup, actions, or failure explanations in separate tests.
- Prefer struct suites with instance-owned fixtures. Do not move mutable
  test data into static storage to avoid repeated setup.

## Parallel execution

Tests may execute in parallel. Isolate files, database stores, preferences,
and other mutable fixtures per test, with cleanup appropriate to their
lifetime. Follow the existing mock boundary instead of replacing services.

Use `.serialized` only when shared-resource access cannot reasonably be
isolated. On a parameterized test it serializes that test's cases; on a
suite it serializes its tests and nested suites. It is not a global lock
against other suites or test processes. `@MainActor` specifies isolation,
not whole-test serialization across suspension points.

## Async completion

Await the operation that makes the result observable. Do not use a sleep to
guess when a task, callback, or stream has finished.

`confirmation()` checks events during its closure; it does not wait for
future callbacks after the closure returns. Await the relevant operation
or owned task inside that closure. For a callback-only API, use a checked
continuation with exactly-once completion or retain an appropriate XCTest
test when conversion would require unrelated production changes.

Exercise cancellation through an observable synchronization point and await
cleanup. Do not leave background tasks running after the test completes.
Use project-approved timeout values and APIs supported by the installed
toolchain; do not invent delays to stabilize flaky tests.

## Validation

Run the affected tests using the project's runner and relevant concurrency
settings. Report what ran, failures, and any mocks with their reasons.
Coverage claims require a measured coverage run under the working agreement.
Do not introduce a migration, benchmark suite, or broad new coverage merely
because this skill was invoked.

## Sources

- [Swift Testing documentation](https://docs.swift.org/latest/documentation/testing/)
- [Migrating from XCTest, including async confirmations](https://docs.swift.org/latest/documentation/testing/migratingfromxctest/)
- Further reading: [Paul Hudson's Swift Testing Pro](https://github.com/twostraws/Swift-Testing-Agent-Skill)
