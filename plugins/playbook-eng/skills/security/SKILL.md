---
name: security
description: Use when handling secrets, credentials, network transport, untrusted input, or stored user data, or when reviewing a change for security exposure
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
