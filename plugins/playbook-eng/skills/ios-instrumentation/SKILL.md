---
name: ios-instrumentation
description: Use when designing, building, or reviewing an iOS app - the instrumentation every release ships with to measure launch, frames, CPU, memory, energy, network, disk, and hot paths, and the tooling that reads each signal
---

# iOS instrumentation

Applies to every iOS app from the design stage. Instrumentation is
tier-one production work under the engineering agreement: the design
names the hot paths and the signals, the production code ships the
instrumentation, and the release report carries the measurements.
[swiftui-performance](../swiftui-performance/SKILL.md) diagnoses a
reported symptom; this skill puts in place what that diagnosis relies on.

Budgets and thresholds are per-project decisions stated in the design.
This skill names no numbers.

## Signals

Every release measures each signal below, for each user flow. The
production column is what the shipped app reports; the development
column is what measures it locally and on CI.

| Signal | In production | In development |
| --- | --- | --- |
| Launch time | `MXAppLaunchMetric`, `MXAppLaunchDiagnostic` | App Launch instrument; `XCTApplicationLaunchMetric` |
| Frame hitches | `MXAnimationMetric` hitch ratio | Animation Hitches instrument; signpost metrics on scrolls and transitions |
| CPU | `MXCPUMetric`, `MXCPUExceptionDiagnostic` | Time Profiler; `XCTCPUMetric` |
| Memory | `MXMemoryMetric`; `MXAppExitMetric` memory exits | Allocations, Leaks, memory graph; `XCTMemoryMetric` |
| Energy | Xcode Organizer battery usage | Energy gauge; Power Profiler instrument |
| Network | `MXNetworkTransferMetric`; `URLSessionTaskMetrics` per request | Network instrument |
| Disk | `MXDiskIOMetric`, `MXDiskWriteExceptionDiagnostic` | File Activity instrument; `XCTStorageMetric` |
| Hot paths | `MXSignpostMetric` | os_signpost track in any instrument; `XCTOSSignpostMetric` |
| Hangs | `MXAppResponsivenessMetric`, `MXHangDiagnostic` | Hangs track; Thread Performance Checker |
| Crashes and exits | `MXCrashDiagnostic`, `MXAppExitMetric` | Xcode Organizer crash reports |

## Production telemetry: MetricKit

- Register one `MXMetricManagerSubscriber` at launch and keep it
  registered for the life of the process. Metric payloads arrive at most
  once a day; diagnostic payloads arrive when the event occurs.
- Persist every payload before parsing it. The payload is the evidence;
  a parser bug must not lose it.
- Forward `jsonRepresentation()` of each payload to the project's sink.
  The sink is a per-project decision; the subscriber is not.
- `MXAppExitMetric` is the only record of memory-limit, watchdog, and
  background-task exits, which never produce a crash report. Report
  each exit reason as its own count.
- MetricKit delivers nothing on the simulator. Use Xcode's Simulate
  MetricKit Payloads command in the Debug menu to exercise the subscriber.

## Hot-path spans

- Every hot path the design names carries an `OSSignposter` interval.
  Begin the interval where the user action enters the code and end it
  where the result is visible.
- Use `mxSignpost` on a log from `MXMetricManager.makeLogHandle` for
  the intervals MetricKit should aggregate in production. Use plain
  `OSSignposter` for the rest.
- Subsystem is the bundle identifier. Category is the feature or layer.
  Interval names are stable identifiers: MetricKit aggregates and
  performance-test baselines key on them, so renaming one resets its
  history.
- Pair spans with `Logger` events for the structured context a span
  cannot carry: counts, sizes, cache hits. Mark user data `.private`.
- Signposts are cheap enough to ship. Do not strip them from release
  builds.

## Measuring locally

- Profile a release build on a physical device. Debug builds and the
  simulator measure the wrong code on the wrong hardware.
- One Instruments template per signal, from the table. Record the
  interaction once as a baseline before changing anything, and compare
  only equivalent captures.
- Per-request network timing comes from
  `urlSession(_:task:didFinishCollecting:)`: record DNS, connect, TLS,
  request, and response durations and the bytes transferred.

## Regression gate: performance tests

- Each hot path has an XCTest performance test using `measure(metrics:)`
  with the metrics from the table: clock, CPU, memory, storage, launch,
  and signpost. Prefer `XCTOSSignpostMetric` on the shipped signpost so
  the test measures the same span production reports.
- Set the baseline on a physical device and commit it. A baseline from
  the simulator is not a baseline.
- The suite runs on every change under the project's build tools. A
  failed performance test is a failure under the working agreement.

## Release report

Before a release, the end-to-end measurement the engineering agreement
requires covers, for each user flow: launch time, hitch ratio of each
scrolling screen, peak memory, CPU time, network bytes, and disk writes,
each compared to the previous release on the same device class. The
MetricKit subscriber, signposts, and performance tests are what make the
report possible; they are not the report.

## Sources

- [Apple: MetricKit](https://developer.apple.com/documentation/metrickit)
- [Apple: OSSignposter](https://developer.apple.com/documentation/os/ossignposter)
- [Apple: XCTMetric](https://developer.apple.com/documentation/xctest/xctmetric)
- [Apple: URLSessionTaskMetrics](https://developer.apple.com/documentation/foundation/urlsessiontaskmetrics)
- [Apple: Analyzing the performance of your shipping app](https://developer.apple.com/documentation/xcode/analyzing-the-performance-of-your-shipping-app)
- [WWDC21: Ultimate application performance survival guide](https://developer.apple.com/videos/play/wwdc2021/10181/)
