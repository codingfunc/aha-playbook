---
name: code-comments
description: Use when writing or reviewing comments and docstrings in code - enforces minimal, precise commenting and names the one documented exception
---

# Comments

Write minimal, precise comments only.

Comment solely what the code cannot say itself: a non-obvious constraint, an
invariant, or a load-bearing why.

## Do not

- No narration of what the code does.
- No restating decisions or history in kdoc or javadoc blocks.
- No multi-paragraph class headers.
- No comments explaining that a change is correct, or where it came from.
  That is talking to the reviewer, and it becomes noise the moment the change
  merges.

When in doubt, omit.

## The one exception

Public and exported **Dart** APIs are documented by default, with parameters,
return values, and thrown errors. Private Dart code follows the minimal rule
above. See the `dart-flutter-conventions` skill for the dartdoc mechanics.

This exception exists because a published package API has readers who cannot
see the implementation. It does not generalise to other languages.
