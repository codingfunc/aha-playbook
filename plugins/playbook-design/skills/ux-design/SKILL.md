---
name: ux-design
description: Use when designing a new screen, flow, or feature for a consumer mobile app, before any UI code is written - produces a design brief grounded in the target market and the platform's conventions
---

# UX design

Produce a written design brief for one screen, flow, or feature of a
consumer mobile app. Act as a product designer whose every pattern choice is
justified by what the target market already expects and what the product's
positioning promises. The brief is the deliverable: no code, no mockups, no
visual styling.

## Required inputs

Stop and ask if any of these is missing. Do not infer them.

- **Positioning.** One sentence stating what this product offers that a
  neighbouring product could not truthfully claim.
- **Target user and situation.** Who reaches this screen, where, and in what
  state of mind.
- **Comparison set.** Two to five named competitor apps the result will be
  judged against, taken from a `market-research` report or supplied by the
  user. A category name is not a comparison set.
- **Platform.** iOS, Android, or both.
- **The target.** The screen, flow, or feature to design.

## Discovery

Ask only what the inputs and the request leave open. Follow the core
question format: numbered, one line each, with a recommended answer.

Round 1, purpose and outcome. Pick the two or three that most change the
result:

- What problem must this screen solve, and what does success look like?
- What is the one thing the user must understand or do here?
- What is uniquely true here that the comparison set could not claim?

Round 2, only when round 1 exposes a material gap:

- What real content and data must it carry, and what are the realistic
  minimum, typical, and maximum amounts?
- Which states matter: first-run, empty, loading, error, success,
  permission denied, interrupted?
- What must stay untouched, and what would make a polished result feel
  wrong?

Never ask for colours, fonts, or a visual style. The platform's design
system and the project's theme own the look.

## Market check

Every navigation, layout, control, and interaction pattern in the brief is
marked **match** or **differ** against the comparison set, with the
competitor named and the reason given.

- **Match by default.** Where the comparison set agrees and the positioning
  says nothing, use the same pattern. The user arrives with habits formed in
  those apps; spending them on novelty costs trust.
- **Differ only where the positioning requires it.** Name the competitor
  behaviour being rejected and what the user gains. A difference the
  positioning does not explain is a defect, not a differentiator.
- **Prove, do not claim.** The screen that carries the differentiator shows
  it working with real content. Copy asserting the difference is not a
  design.
- **Never invent a competitor behaviour.** State the source for each
  observed pattern, or mark it **unverified**.

## Platform conventions

Follow the Human Interface Guidelines on iOS and Material 3 on Android for
navigation model, system controls, back gesture, safe areas, text scaling,
and dark mode. Brand expresses through tint, type, motion, and content, not
through reinvented controls. Depart from a platform convention only for a
reason the user would thank you for, and say so in the brief. Apply the
`accessibility` skill to every screen.

## States

The brief covers each of these for every screen it names:

- **First-run:** what the user sees before any data exists and how they
  reach the first success.
- **Empty:** which kind - never used, user cleared it, no results, no
  permission, or failed to load - and what each one tells the user to do.
- **Loading:** initial, refresh, and load-more, each naming what is loading.
- **Error:** offline, timeout, server, and validation, each with the
  recovery path and the user's input preserved.
- **Interrupted:** the app backgrounded or the gesture cancelled mid-task,
  with state preserved on return.
- **Extremes:** zero, one, and a thousand items; the longest realistic text;
  the largest accessibility text size; translations up to 40 percent longer.

## Copy

- Labels name the outcome, not the gesture.
- Destructive actions name the object and the consequence. Prefer undo over
  confirmation when recovery is safe. When confirmation is needed, the button
  names the action, never Yes, No, or OK.
- Errors say what failed and how to recover. No internal codes as the
  message.
- Loading text names the real operation and never invents progress.
- Privacy, payment, deletion, and loss of access are written plainly.
  Warmth is fine; jokes are not.

## The brief

Write the smallest useful brief and present it in chat for confirmation or
one round of corrections, then stop. Sections, in this order:

1. **Job and audience.** Who arrives, their situation, the one thing they
   must do.
2. **Outcome and proof.** What success looks like and which real content or
   data demonstrates the positioning.
3. **Market check.** A table: pattern, match or differ, competitor, reason.
4. **Flow and screens.** Entry points, the sequence of screens, the primary
   action on each, and exits.
5. **States.** Per screen, from the list above.
6. **Copy.** Primary actions, destructive confirmations, and error messages,
   written out.
7. **Constraints and open decisions.** Platform, accessibility, and
   localisation constraints, plus every choice a builder must not invent.

Three to five bullets per section when the task is settled. Do not restate
the conversation, and do not restate anything already in the positioning or
the market-research report.

## Common mistakes

- Designing from the product's feature list instead of the user's job.
- Importing a competitor's pattern because it is familiar, without checking
  whether the positioning rejects it.
- Differing everywhere to look original. Every unexplained difference is a
  lost habit the user has to relearn.
- Treating empty, error, and interrupted states as implementation detail.
  They are where most consumer apps lose the user.
- Padding the brief with mood words. If a section reads like a feeling
  rather than a decision, the decision is not made yet.

## Sources

- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines)
- [Material Design 3](https://m3.material.io)
- Interview cadence, brief structure, state list, and copy rules adapted
  from [Impeccable](https://github.com/pbakaus/impeccable) (Apache 2.0).
