---
name: security
description: Use when handling secrets, credentials, network transport, untrusted input, dependencies, or stored user data, or when reviewing a change for security exposure
---

# Security

Apply checks to the code under change and the data it touches. Treat an
unstated limit, algorithm, or retention period as a question for the project,
not a value to choose. Do not expand a scoped task into an unrequested
whole-system audit.

## Secrets and credentials

- Keep credentials out of source, version control, log output, and crash
  reports. A secret committed once stays disclosed until it is rotated;
  report it rather than only removing it from the working tree.
- Build-time configuration and runtime user credentials are separate
  problems. Store user credentials and tokens in the platform's protected
  store, not in general-purpose preferences.
- A secret shipped inside a client binary is readable by anyone holding the
  binary. If a key must stay private, the operation belongs on a server.
- Scope, expiry, and refresh behavior belong to the token's issuer. Ask for
  the intended lifetime rather than inferring one.

## Transport and external interfaces

- Use the platform's default transport protections and keep certificate
  validation enabled. An exception added for a local or test environment
  must not reach a shipping configuration.
- Treat every external boundary as untrusted: network responses, deep links,
  pasteboard contents, files, inter-process messages, and embedded web
  content. Validate shape and range, not only type.
- Fail closed on a validation error. A malformed response surfaces an error;
  it does not produce a partially populated model.

## One validation boundary

Route external input through a single module whose job is validation, rather
than checking at each call site. Name each validator for what it guards — a
URL, a path, a label, a payload shape — and give it one behaviour: return the
validated value, or raise.

The reason: scattered checks cannot be audited. With one module you can read
every entry point into the system in a single file, and a caller that skips
it is visible in review.

Validate at the seam, before the consumer runs. A schema check that happens
after the data has reached the store or the view has prevented nothing.

## Dependencies and supply chain

- A dependency is untrusted code you ship. Audit the declared set for known
  vulnerabilities in CI, not by hand, and fail the build on a finding.
- Commit the lockfile and install from it frozen everywhere — local, CI, and
  release. An unpinned install makes the audit meaningless.
- Every version floor, cap, and optional extra carries its reason beside it:
  the CVE it clears, the incompatibility it avoids, the platform that has no
  prebuilt binary. A bare pin cannot be maintained, because the next person
  cannot tell whether it is still needed.
- Run a static analyser over your own source in the same job, and record any
  skipped rule with the reason.

## Stored data and diagnostics

- Decide what actually needs to persist. Data never stored cannot leak.
- Match protection to sensitivity using the platform's own storage classes
  rather than a scheme invented for the project.
- Keep personal data, credentials, and tokens out of logs, analytics events,
  and error payloads. Redact at the call site, not in a later filter.

## Verification and findings

Name the asset, the exposure path, and who can reach it. Report the affected
location, the concrete impact, and the smallest remedy. Distinguish a
source-level finding from a demonstrated one, and do not describe a system as
secure because a review found nothing. When a fix depends on a project value
such as a retention period, a rotation interval, or an allowed origin, ask
for it.

For platform specifics, read the Security sections of
[swift-conventions](../swift-conventions/SKILL.md) and
[dart-flutter-conventions](../dart-flutter-conventions/SKILL.md).

## Sources

- [OWASP Mobile Application Security Verification Standard](https://mas.owasp.org/MASVS/)
