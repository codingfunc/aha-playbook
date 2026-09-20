---
name: handoff
description: Use when asked to transfer work to another session or agent - captures decisions, progress, verification, and the next action without duplicating existing artifacts
---

# Handoff

Prepare a Markdown handoff for a fresh agent. Tailor it to the user's stated
next-session focus; otherwise preserve the current task and its boundaries.
The core document approval gate applies: draft in chat, then save the
approved content to the OS temporary directory unless the user specifies
another location. Report its absolute path.

Include only the context needed to resume:

- **Objective and scope:** intended outcome, constraints, and completion criteria.
- **Decisions:** what was agreed, why, and what remains unresolved.
- **Current state:** completed work, outstanding work, blockers, and any
  running process whose state the next agent needs to check.
- **Workspace:** repository path, branch, relevant files, and uncommitted
  changes. Distinguish task changes from pre-existing changes when known.
- **Verification:** checks actually run and their outcomes; checks still
  needed. Separate observed results from assumptions.
- **Next action:** the concrete next step and any approval still required.
- **Relevant skills:** available skills the next agent should consult and why.

Reference specs, plans, ADRs, issues, commits, and diffs by path or URL rather
than copying them. Preserve decisions that exist only in the conversation.
Remove secrets and unnecessary personal information. Record credential
locations only when needed, never credential values.

A handoff records existing authorization; it does not grant new permission.
Mark stale or unverified state so the next agent checks it before acting.

Adapted from Matt Pocock's `handoff`; see [attribution](../../THIRD_PARTY_NOTICES.md).
