---
name: accessibility
description: Use when designing or reviewing interface accessibility, assistive-technology semantics, text scaling, motion, focus, or non-color cues
---

# Accessibility

Apply checks to the requested interface and its supported platforms. Preserve
the product's visual intent while making its information and actions usable
with assistive technology. Do not expand an ordinary UI task into an
unrequested whole-product audit.

## Semantics and interaction

- Prefer native controls with built-in activation, role, state, and focus
  behavior. A custom gesture needs equivalent accessible interaction.
- Give each action a meaningful accessible name, including visually
  icon-only actions. Expose values and selected, expanded, or disabled state
  where relevant; avoid repeating a role the platform already announces.
- Hide purely decorative imagery from assistive technology. Describe
  informative imagery by its purpose rather than its asset filename.
- Group content according to meaning without hiding separately actionable
  children. Check reading order and focus when content changes or modals close.
- Ensure supported keyboard and assistive-input paths can reach and operate
  every action, with visible focus and no traps.

## Adaptation

- Support system text scaling and reflow. Check long labels and accessibility
  text sizes for clipping, overlap, hidden actions, and lost information.
- Do not convey an error, selection, or status through color alone. Pair it
  with text, shape, an icon, or another perceivable cue.
- Check contrast in supported appearances and increased-contrast settings.
  Use the applicable platform or project standard rather than inventing one.
- Honor reduced-motion preferences for substantial movement while preserving
  feedback. Avoid making essential information depend on animation.

For SwiftUI implementation or review, read
[SwiftUI accessibility](references/swiftui.md). Keep other platform-specific
APIs out of this shared checklist.

## Verification and findings

Walk the affected user flow using the platform's screen reader and relevant
input modes, text sizes, and display preferences. Automated inspection can
find some defects; it does not establish that the flow is usable.

When runtime access is unavailable, distinguish source-level findings from
unverified interaction behavior. Report the affected element, user impact,
location, and smallest remedy. State what was actually exercised; do not
claim accessibility compliance from source review alone.

## Sources

- [Apple Human Interface Guidelines: Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)
- Further reading: [Paul Hudson's SwiftUI accessibility guidance](https://github.com/twostraws/SwiftUI-Agent-Skill/blob/main/swiftui-pro/references/accessibility.md)
