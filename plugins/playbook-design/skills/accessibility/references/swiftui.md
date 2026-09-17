# SwiftUI accessibility

Check the deployment target before selecting APIs. Use semantic fonts such
as `.body` and `.headline`; scale custom dimensions with `@ScaledMetric`
where appropriate. Do not cap Dynamic Type merely to preserve a fixed layout.
Adapt stacks, wrapping, and scrolling to retain content and actions.

For an icon-only action, preserve an accessible text label:

```swift
Button("Add item", systemImage: "plus", action: addItem)
    .labelStyle(.iconOnly)
```

Use `accessibilityLabel` for a meaningful name when native content does not
provide one, `accessibilityValue` for the current value, and a hint only when
the result of activation is unclear. Check the final spoken output rather
than adding redundant labels to every control.

Use `Image(decorative:)` or `accessibilityHidden(true)` for decoration.
Before combining children with `accessibilityElement(children: .combine)`,
verify that no child action needs independent focus.

Prefer `Button` over a tap gesture for an action. If a gesture is essential,
provide an accessible action and suitable traits; adding `.isButton` alone
does not implement all button behavior.

Read `accessibilityReduceMotion` to replace large spatial transitions with
less motion, such as a brief opacity change where appropriate. Read
`accessibilityDifferentiateWithoutColor` and use non-color cues for meaningful
distinctions; essential meaning should already be available without color.

Use Accessibility Inspector to examine names, values, traits, and grouping.
Verify with VoiceOver that the affected flow has a sensible reading order,
usable controls, and appropriate focus after presentation or dismissal.
Check Voice Control names for controls with changing visual labels, and
supported keyboard navigation on the relevant Apple platforms.

## Sources

- [SwiftUI accessibility](https://developer.apple.com/documentation/swiftui/accessibility)
- [Reduce Motion environment value](https://developer.apple.com/documentation/swiftui/environmentvalues/accessibilityreducemotion)
