---
name: testing-standards
description: Use when writing integration or unit tests - defines what may be mocked and what may not, and when tests get written
---

# Testing standards

## What may be mocked

In an integration test, **never mock a service class.** Mock only the
low-level client: the GraphQL client, the REST client, the database driver.

The reason: mocking a service class tests that your mock matches your
assumptions. Mocking at the client boundary leaves the real service logic —
the part that breaks — under test.

## When tests get written

Production code first, then review, then tests. Do not write tests until the
implementation review is approved. Writing them earlier means rewriting them
when the review changes the design.

## Test design

A test names the behaviour it protects, not the method it calls. If a test
fails and the name does not tell you what broke, rename it.

Never invent expected values. If the spec does not state what the output
should be, stop and ask rather than asserting whatever the code currently
returns.
