---
name: diagnosing-bugs
description: Use when diagnosing a reported bug or performance regression - establishes a reproducible symptom, tests causal hypotheses, and verifies the original behavior after a fix
---

# Diagnosing bugs

Ground diagnosis in an observable symptom. Existing core stop conditions
and engineering approval gates apply throughout; this workflow does not
authorize repeated attempts, production instrumentation, or test-first work.

## Establish a reproduction

Record the reported behavior, expected behavior and its source, reproduction
steps, environment, and relevant recent changes. Use available evidence
before requesting missing details. Redact secrets from commands, logs, and
captured requests.

Choose the smallest available observation that can distinguish the actual
symptom: an existing test, CLI command, request, UI interaction, or captured
trace. State its expected verdict before running it. A command that merely
finishes without error is insufficient if it cannot detect this bug.

Show the invocation or steps and the observed result. A reproduced symptom
is evidence, not an unexpected failure of the diagnostic approach. If the
approach fails to reproduce or encounters an unexpected roadblock, follow
the core stop condition: report it and ask before trying alternatives.

If reproduction needs new code or a harness, propose the approach under the
engineering design gate first. Do not create a regression test before
implementation review. When reproduction is unavailable, report the missing
access or evidence and distinguish code-level hypotheses from confirmed causes.

## Narrow the cause

Within the agreed diagnostic approach, reduce the reproduction by changing
one input or condition at a time while preserving the reported symptom.
For intermittent behavior, record observed frequency and conditions without
inventing a repetition count, load target, or timing threshold.

Present plausible hypotheses, ranked by evidence. Each hypothesis needs a
prediction: what observation would support or refute it? Choose a targeted
probe that distinguishes the leading alternatives. A predicted negative
result can refute a hypothesis; an unexpected failure invokes the stop gate.

Prefer existing debugger or profiler evidence. Propose any added
instrumentation before editing code, give temporary instrumentation a
searchable marker, and keep probes focused on the hypothesis.

For performance regressions, establish the affected flow and measured
baseline before proposing an optimization. Compare equivalent environments
and inputs; use [swiftui-performance](../swiftui-performance/SKILL.md) for
SwiftUI-specific investigation. An unmeasured change is not a proven speedup.

## Fix and verify at the existing gates

Present the supported cause and smallest proposed fix for design approval.
After implementation, rerun the original reproduction and request
implementation review. Only after that review is approved, add a regression
test at a seam that exercises the real failure pattern, following
[testing-standards](../testing-standards/SKILL.md).

If no suitable test seam exists, explain the limitation rather than adding
a shallow test that cannot detect the bug. New test seams or non-trivial
failure scaffolding need the applicable design and testing approvals.

Remove temporary instrumentation introduced by this work when its diagnostic
purpose is complete. Preserve existing instrumentation and unrelated files.
Report the cause, change, before/after evidence, checks actually run, and
remaining uncertainty. Distinguish a verified fix from pending review or
regression coverage. Do not proceed across approval gates or commit implicitly.

Adapted from Matt Pocock's `diagnosing-bugs`; see [attribution](../../THIRD_PARTY_NOTICES.md).
