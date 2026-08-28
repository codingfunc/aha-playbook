---
name: token-economy
description: Use when reading files, running builds or tests, or handling large generated artifacts - keeps context spend proportionate to the task
---

# Token economy

## Reading

For files over roughly 200 lines, do not read the whole file speculatively.
Locate the relevant section first — by structure or search — then read with
an offset and a limit.

## Command output

Never dump full command output into context. For test runs, builds, and logs,
filter to the failure and summary lines, then read only those.

## Generated artifacts

Generated and large artifacts — mock HTML, lockfiles, build output — are
write-only. Never read one back to verify it, unless it has failed.

(The companion rule, never re-reading a file already read this session, is in
the core working agreement because it applies outside code work too.)
