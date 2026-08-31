---
name: swift-conventions
description: Use when writing Swift code - language style, concurrency, error handling, value types, optionals, and API design conventions
---

# Swift conventions

## Language Style
* **API Design Guidelines:** Follow Apple's Swift API Design Guidelines
  (https://www.swift.org/documentation/api-design-guidelines/). Clarity at
  the point of use wins over brevity.
* **Guard for early exits:** Use `guard` to validate preconditions and exit
  early. Keep the happy path at the lowest indentation level.
* **Value types first:** Prefer `struct` over `class`. Use a class only when
  identity or reference semantics is genuinely required.
* **Immutability:** Prefer `let` over `var`. Model data as immutable value
  types; produce new values instead of mutating.
* **Exhaustive switches:** Prefer exhaustive `switch` over `default` cases so
  the compiler flags new enum cases.

## Concurrency
* **Strict concurrency:** Compile with Swift 6 strict concurrency. Treat
  concurrency warnings as errors — never suppress or ignore them.
* **async/await only:** Use `async`/`await` for all asynchronous work. No
  completion handlers in new code; wrap legacy callback APIs with
  continuations at the boundary.
* **Actors for shared state:** Protect shared mutable state with an actor.
  Mark UI-facing types `@MainActor`.
* **Sendable:** Make types crossing concurrency boundaries `Sendable`;
  prefer making the type a value type over annotating your way out.

## Optionals
* **No force unwrapping:** Never use `!` (force unwrap, force cast, or
  implicitly unwrapped optionals) without a comment stating why the value is
  guaranteed non-nil. Prefer `guard let` / `if let`.
* **Fail loudly at boundaries:** When absence of a value is a programming
  error, `preconditionFailure` with a message beats a silent `?? default`.

## Error Handling
* **Typed errors:** Define domain error enums conforming to `LocalizedError`.
  Wrap underlying errors rather than letting them leak through layers.

  ```swift
  enum AppError: LocalizedError {
      case network(underlying: Error)
      case validation(message: String)

      var errorDescription: String? {
          switch self {
          case .network(let error): error.localizedDescription
          case .validation(let message): message
          }
      }
  }
  ```
* **No silent failure:** Every `catch` either recovers meaningfully,
  surfaces the error to the user, or rethrows. Never swallow.

## Testing
* **Swift Testing framework:** Use Swift Testing (`@Test`, `#expect`) for new
  tests, not XCTest. What may be mocked is governed by `testing-standards`.
* **Design for injection:** Take dependencies through initializers behind
  protocols so tests can substitute them.

## Comments and Documentation
* Follow `code-comments`. Public API documentation uses `///` doc comments,
  matching the documented-exception rule there.
