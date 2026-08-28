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

## Order of work

- **Production code first.** Implement the production code and ask for
  review. Do not write tests until that review is approved.

## Git

- **Never `git commit` or `git push` without explicit approval.** No
  exceptions — every repo, every branch, every worktree. This applies to
  subagents. `git add` is permitted with approval.
- **No Claude attribution** in commit messages.
