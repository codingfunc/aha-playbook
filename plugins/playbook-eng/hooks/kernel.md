# Working agreement — software engineering

Applies to any task that produces or modifies code. The core working
agreement applies as well.

## Before writing code

- **Architecture first.** Present a brief, bulleted outline of the technical
  approach and the design decisions. State assumptions explicitly. WAIT FOR
  APPROVAL before writing any code.
- **Validate design decisions rather than exploring.** Do not run
  exploratory work that the design does not call for.
- **Say so when a simpler approach exists.**
- **No speculative code.** Do not write plug-and-play guesswork. If unsure
  about a dependency, an API, or a requirement, pause and ask.

## Performance

- **Performance is a first-class concern.** Design for correctness and
  performance together, from the start. Never treat performance as a
  later optimisation pass.
- **State the performance characteristics in the design.** The
  architecture outline names the hot paths and the expected cost of each:
  complexity, I/O, allocations, or latency, whichever applies.
- **Instrument the hot paths.** Add logs and metrics around them so
  performance can be measured, not assumed. A performance claim without a
  measurement is speculation.
- **Test performance end to end before release.** Hot-path instrumentation
  is the starting point, not the finish. Before a release, measure the
  full flow a user experiences, not just the parts the design flagged.

## Order of work

- **Production code first.** Implement the production code and ask for
  review. Do not write tests until that review is approved.
- **Happy paths first.** Cover every happy path before any edge case or
  failure case. Before writing an edge-case or failure test that needs
  non-trivial setup, describe the scenario and ask whether it is worth
  covering. Do not build elaborate test scaffolding unprompted.
- **Project coverage floor is 90%.** Line coverage across the whole
  project must stay at or above 90%. This is a project-wide figure, not a
  per-commit one. Report the measured figure with the tests; do not claim
  the floor is met without running the coverage tool.
- **Prefer real code over mocks.** Test against the actual implementation
  wherever it can run. When a mock is used, name it and say why in the
  report.

## Token economy

- **Read large files in chunks.** For files over roughly 200 lines, do not
  read the whole file speculatively. Locate the relevant section first — by
  structure or search — then read with an offset and a limit.
- **Never dump full command output into context.** For test runs, builds,
  and logs, filter to the failure and summary lines (`head`, `tail`, `grep`),
  then read only those.
- **Generated artifacts are write-only.** Mock HTML, lockfiles, build
  output: never read one back to verify it, unless it has failed.

## Git

- **Never `git commit` or `git push` without explicit approval.** No
  exceptions — every repo, every branch, every worktree. This applies to
  subagents. `git add` is permitted with approval.
- **No Claude attribution** in commit messages.
