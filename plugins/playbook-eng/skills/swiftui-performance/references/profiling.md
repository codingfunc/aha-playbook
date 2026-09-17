# Profiling a SwiftUI interaction

Use the project's profiling configuration, normally an optimized build on
a representative device. Record configuration differences when only a
simulator or Debug build is available; do not compare those captures as if
they were equivalent.

Choose instruments based on the symptom and installed Xcode support:

| Symptom | Evidence to collect |
| --- | --- |
| Slow or frequent view updates | SwiftUI instrument when available; update duration and dependency causes |
| Hangs or CPU spikes | Time Profiler call stacks during the affected interaction |
| Scrolling hitches | Animation Hitches and relevant main-thread work |
| Memory growth | Allocations and Memory Graph; retained objects after leaving the flow |

Capture the same interaction with comparable data and cache state before
and after a change. Include the full user flow, not just an isolated helper.
Use signposts or the project's existing instrumentation to correlate stages
when the trace alone cannot identify them. Avoid logging sensitive payloads
or adding high-volume instrumentation that distorts the measurement.

Record observed duration, hitch behavior, CPU, or memory as relevant to the
symptom. Report run-to-run variation rather than selecting the best sample.
Do not claim a target was met unless the project supplied that target.

If tools cannot be run in the current environment, request the relevant
trace or capture with reproduction steps and build/device details. Explain
what the evidence needs to resolve; do not ask for an entire project when a
specific interaction and call tree suffice.

Source: [Apple: Optimize SwiftUI performance with Instruments](https://developer.apple.com/videos/play/wwdc2025/306/)
