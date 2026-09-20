---
name: testing-standards
description: Use when writing integration or unit tests - defines where a mock is allowed to sit and how a test is designed
---

# Testing standards

## What may be mocked

The working agreement sets the default: test the real code, and name every
mock in the report with the reason. A mock is justified only when the real
dependency cannot run in the test: a network service, a paid API, a clock,
a random source.

In an integration test, **never mock a service class.** Mock only the
low-level client: the GraphQL client, the REST client, the database driver.

The reason: mocking a service class tests that your mock matches your
assumptions. Mocking at the client boundary leaves the real service logic —
the part that breaks — under test.

## Isolation

A unit test touches nothing outside the process: no network calls, and no
filesystem writes outside the temporary directory the framework provides and
removes. A test that leaves state behind passes alone and fails in a suite.

One test file per module under test. When one module's tests outgrow a single
file, that usually means the module is doing too much.

## Test design

A test names the behaviour it protects, not the method it calls. If a test
fails and the name does not tell you what broke, rename it.

Never assert whatever the code currently returns. If the spec does not state
the expected output, stop and ask; a test that snapshots current behaviour
protects a bug as readily as a feature.
