---
name: diagnosing-bugs
description: Use when the user asks for the cause of a reported failure, crash, wrong output, or slowdown - builds a feedback loop that goes red on the symptom before any theory, then tests ranked hypotheses one at a time
---

# Diagnosing bugs

Applies when the user has asked you to find the cause of a failure. A test
or build that fails while you are working is not this skill: stop and
report it, as the working agreement says, and wait to be asked.

Redact every secret before showing a command, an output, or a captured
artifact. Build loops against environment variables so credentials never
appear in what you show.

## 1. Build the loop

Produce one command that goes red on the reported symptom. It must be
deterministic, run in seconds, and run unattended. Prefer, in order:

1. A failing test at the nearest public interface.
2. A script or CLI call with a fixture input, diffed against known-good
   output.
3. A request against a running dev server.
4. A replay of a captured input through the code path in isolation.

For a flaky bug, the goal is a higher reproduction rate, not a clean
repro. Loop the trigger, add stress, narrow the timing until it fails
often enough to debug.

For a slowdown the loop is a measurement, not an assertion: record a
baseline, then bisect between the known-good and known-bad states.

**Gate.** Do not read code for causes until the command exists and you
have run it once and shown its redacted output. If the first loop you
build does not go red, that is a failure under the working agreement:
present what it did and ask. If no loop can be built, stop, list what
you tried, and ask for one of: access to an environment that reproduces
it, a redacted captured artifact, or permission to add temporary
instrumentation.

## 2. Minimise

Cut inputs, configuration, data, and steps one at a time, rerunning the
loop after each cut. Keep only what is load-bearing. Done when removing
any remaining element turns the loop green.

Confirm the loop fails with the symptom the user described, not a nearby
one. The wrong bug gets the wrong fix.

## 3. Hypothesise, then stop

List three to five ranked causes. Each carries a prediction: "if X is the
cause, then changing Y makes the loop go green." A cause with no
prediction is a guess; drop it or sharpen it.

Show the list and wait. Do not probe before the user responds. They will
often strike causes you cannot, and reorder the rest.

## 4. Probe

Take the hypotheses in the agreed order, one at a time, changing one
variable per probe. Prefer a debugger or a single breakpoint over logs.
Every debug log carries one tag unique to this session, such as
`[DBG-7f3a]`, so cleanup is a single grep. Filter all output to the lines
that bear on the prediction.

A falsified hypothesis moves you to the next. A confirmed one ends this
phase. If every hypothesis is falsified, stop and report; do not generate
a new list unprompted.

## 5. Fix and verify

The fix is production code: the smallest change that addresses the
confirmed cause, within the scope rules of refactoring-discipline. Rerun
the original, unminimised loop and show it green.

Remove every tagged log by grepping the tag. Delete the throwaway loop,
unless it is already a test at the right interface; then leave it for
review as the regression-test candidate.

Ask for review, as the order of work requires. State the confirmed cause
in the report.

## 6. After review

Once the fix is approved, the test-writer turns the minimised repro into
the regression test at the interface where the bug occurred. If no
interface can hold that test, say so: the shape of the code is stopping
the bug from being locked down, and that is a finding for the user.

Adapted from `diagnosing-bugs` in Matt Pocock's skills repo, MIT
licensed: https://github.com/mattpocock/skills
