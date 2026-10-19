# Async boundaries

## Callback adapters

Use a checked continuation when an async variant is unavailable. Enumerate
every callback, synchronous failure, and cancellation path: a continuation
must resume exactly once. Multiple callbacks need a stream or another
explicit protocol, not repeated continuation resumes.

A continuation does not automatically cancel the underlying operation.
When adding cancellation handling, account for cancellation arriving before
registration, during registration, or concurrently with completion. Protect
the completion state and underlying operation handle consistently; avoid
calling external callbacks while holding a lock.

Do not block an executor with a semaphore while waiting for async work.
Keep unavoidable synchronous interop localized and document its ownership.

## Streams

Specify whether values may be dropped, buffered, or must exert backpressure.
An unbounded buffer can retain an indefinitely growing backlog; choose a
policy from the consumer's contract rather than an arbitrary buffer size.
`AsyncStream` buffering alone is not producer backpressure.

Finish streams on terminal completion or failure. Arrange termination
cleanup for subscriptions, observers, and producer tasks, and verify that
the cleanup does not introduce a retain cycle or race with delivery.

## Cancellation and shared work

Check which task owns a shared operation before cancelling it. One caller
losing interest need not cancel work required by other callers. State what
the individual waiter and shared producer do on cancellation.

When removing an in-flight entry after suspension, ensure it still refers
to this operation; an older completion must not erase a replacement request.
Likewise, do not publish a stale response after invalidation or a newer load.

## Sources

- [Checked continuations](https://developer.apple.com/documentation/swift/checkedcontinuation)
- [AsyncStream](https://developer.apple.com/documentation/swift/asyncstream)
