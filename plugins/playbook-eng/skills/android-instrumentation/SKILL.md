---
name: android-instrumentation
description: Use when designing, building, or reviewing a native Android app - the instrumentation every release ships with to measure startup, frames, CPU, memory, energy, network, disk, and hot paths, and the tooling that reads each signal
---

# Android instrumentation

Applies to every native Android app from the design stage. Instrumentation
is tier-one production work under the engineering agreement: the design
names the hot paths and the signals, the production code ships the
instrumentation, and the release report carries the measurements.

Budgets and thresholds are per-project decisions stated in the design.
This skill names no numbers.

Android has no on-device equivalent of MetricKit. Production signals come
from two places: Android Vitals in Play Console, which the platform
collects without app code, and on-device APIs whose output the app must
ship to its own sink. The sink is a per-project decision; the
instrumentation is not.

## Signals

| Signal | In production | In development |
| --- | --- | --- |
| Startup | Vitals cold, warm, and hot start; `reportFullyDrawn()` | Macrobenchmark `StartupTimingMetric`; Perfetto |
| Frame hitches | JankStats per-frame reports; Vitals slow and frozen frames | Macrobenchmark `FrameTimingMetric`; Perfetto frame timeline |
| CPU | Vitals excessive wakeups and stuck wake locks | CPU Profiler; Perfetto |
| Memory | `ApplicationExitInfo` low-memory exits; `onTrimMemory` levels | Memory Profiler; heap dumps; Perfetto memory counters |
| Energy | Vitals wakeups and wake locks | Power Profiler; Battery Historian from a bug report |
| Network | `TrafficStats` bytes per UID; per-request timing from the HTTP client's event hooks | Network Inspector |
| Disk | StrictMode disk-on-main-thread in debug; `StorageStatsManager` footprint | Perfetto disk I/O; system trace |
| Hot paths | `androidx.tracing` sections in a profileable release build | Macrobenchmark `TraceSectionMetric`; Perfetto; System Trace |
| ANRs | Vitals ANR rate; `ApplicationExitInfo` ANR traces | StrictMode penalties in debug |
| Crashes and exits | Vitals crash rate; `ApplicationExitInfo` reasons | Logcat |

## Hot-path spans

- Every hot path the design names is wrapped in a `trace("name") { }`
  section from `androidx.tracing:tracing-ktx`, or `Trace.beginSection`
  and `endSection` where a lambda does not fit. Use
  `beginAsyncSection` for work that spans threads or coroutines.
- Section names are stable identifiers: Macrobenchmark metrics and
  Perfetto queries key on them, so renaming one resets its history.
- Mark the release build `<profileable android:shell="true" />` in the
  manifest. Without it a release build emits no trace sections and
  Macrobenchmark cannot measure it. Profileable exposes no app data.
- Keep sections in release builds. The library emits nothing unless a
  tracing session is active, so shipped sections cost almost nothing.

## Production telemetry

- Call `reportFullyDrawn()` when the first screen is usable, not when it
  is first drawn. Vitals and Macrobenchmark both read time to full
  display from it; without the call, startup is measured to the wrong
  point.
- Create one `JankStats` per window with `JankStats.createAndTrack` and
  tag application state through `PerformanceMetricsState` so each janky
  frame carries the screen and scroll state it happened in. Report the
  jank rate and the tagged states to the sink.
- Read `ActivityManager.getHistoricalProcessExitReasons` on the next
  launch after an exit and report each reason as its own count: crash,
  native crash, ANR, low memory, excessive resource usage, and the rest.
  Low-memory and ANR exits never produce a crash report otherwise.
- Implement `onTrimMemory` and report the level. It is the only signal
  the platform sends before killing the process for memory.
- Read `TrafficStats.getUidRxBytes` and `getUidTxBytes` per session for
  bytes transferred. Per-request timing comes from the HTTP client's
  event hooks, which the design names.

## Debug-build guards: StrictMode

In `Application.onCreate`, under the debug build flag only:

- Thread policy detecting disk reads, disk writes, network, custom slow
  calls, resource mismatches, and unbuffered I/O on the main thread.
- VM policy detecting leaked closable objects, leaked SQLite objects,
  activity leaks, and cleartext network.
- Penalty is log at minimum. Whether a violation also crashes the debug
  build is a per-project decision.

StrictMode catches main-thread and leak mistakes at the moment they are
written, before any profiler would find them.

## Measuring locally

- Profile a release build on a physical device. Debug builds skip the
  compiler optimisations that decide performance, and the emulator
  measures the wrong hardware.
- Studio's CPU, Memory, Power, and Network tools for the matching
  signal; Perfetto for anything that crosses process or thread
  boundaries. Record one capture as a baseline before changing anything,
  and compare only equivalent captures.
- Export a bug report for Battery Historian when energy must be judged
  over a session longer than a profiler run.

## Regression gate: Macrobenchmark

- A macrobenchmark module with `MacrobenchmarkRule` covers each hot path
  with the metrics from the table: `StartupTimingMetric`,
  `FrameTimingMetric`, and `TraceSectionMetric` on the shipped section
  names, so the benchmark measures the same span production reports.
- Benchmarks run on a physical device against the profileable release
  build, with the compilation mode the design states. Results land in
  the build outputs as JSON; keep the previous run to compare against.
- Generate a baseline profile with `BaselineProfileRule` and ship it.
  Startup and first-use jank are measured with the profile installed,
  because that is what users run.
- Microbenchmark with `BenchmarkRule` covers pure-code hot paths that do
  not need the UI.
- A failed benchmark is a failure under the working agreement.

## Release report

Before a release, the end-to-end measurement the engineering agreement
requires covers, for each user flow: time to full display, jank rate of
each scrolling screen, peak memory, CPU time, network bytes, and disk
writes, each compared to the previous release on the same device class.
The trace sections, JankStats, exit reasons, and benchmarks are what make
the report possible; they are not the report.

## Sources

- [Android: App startup time](https://developer.android.com/topic/performance/vitals/launch-time)
- [Android: JankStats](https://developer.android.com/topic/performance/jankstats)
- [Android: Android vitals](https://developer.android.com/topic/performance/vitals)
- [Android: Tracing overview](https://developer.android.com/topic/performance/tracing)
- [Android: Macrobenchmark](https://developer.android.com/topic/performance/benchmarking/macrobenchmark-overview)
- [Android: Baseline Profiles](https://developer.android.com/topic/performance/baselineprofiles/overview)
- [Android: StrictMode](https://developer.android.com/reference/android/os/StrictMode)
- [Android: ApplicationExitInfo](https://developer.android.com/reference/android/app/ApplicationExitInfo)
- [Android: Profile your app performance](https://developer.android.com/studio/profile)
