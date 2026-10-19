---
name: handoff
description: Use when ending a session, writing or updating a handoff, revising a design spec, or adopting the layout in a project whose instruction file has become a log - keeps the loaded snapshot small and moves history to a searchable folder
---

# Handoff

A project's record has two tiers. The snapshot is what a new session loads;
it holds conclusions. History is what a session searches; it holds reasons.
Nothing moves from history back into the snapshot.

## The snapshot

`docs/handoff/CURRENT.md`. Rewritten whole at every handoff, never appended
to. At most 100 lines.

Sections, in order:

- **Goal** — one paragraph.
- **State** — what works, what is in progress, the branch.
- **Decisions in force** — one line each, stated as the decision, linking the
  history entry that holds its reasons. Only decisions not yet in the spec.
- **Open questions**
- **Next step**
- **Files in play**
- **History** — this line, verbatim:
  "Earlier sessions and the reasons behind decisions are in
  `docs/handoff/history/`. Before re-deciding anything or asking why, list
  that folder, read the first line of likely entries, then read only the
  match."

Over 100 lines means decisions that belong in the spec are sitting in the
snapshot. Move them; do not raise the cap.

## History

`docs/handoff/history/YYYY-MM-DD-<topic>.md`, one per handoff, never edited
after it is written. Two entries on one day take distinct topics.

The first line is a one-sentence summary. The filenames and first lines are
the index; there is no separate index file. The body records what changed,
each decision with its reasons, and the alternatives rejected.

Previous snapshots are not copied here; git holds them.

## Specs

A spec describes the system as it is. When the design changes, rewrite the
affected sections in place; no "originally" or "v1" passages. The reason for
the change goes in that day's history entry. Superseded text is in git.

When a decision in the snapshot is settled, write it into the spec and drop
it from the snapshot.

## Adopting the layout

A project arriving with its own record, an instruction file that has grown
into a dated log or a context file of checkpoints, is converted once, in one
handoff:

- Archive the instruction files verbatim in one dated design note or history
  entry. Git holds them too, but the reading rule searches folders, not git.
- The instruction file keeps rules only, compressed, with a Record rule that
  names this skill. Decisions the spec already states are referenced, not
  repeated. A statement that is no longer true is dropped and listed in the
  adoption entry.
- The harness's instruction file loads the snapshot; in Claude Code that is
  an `@docs/handoff/CURRENT.md` line in CLAUDE.md.
- The existing log is frozen where it is with a note under its title; it is
  neither split nor deleted. The snapshot's History section names it as the
  record before the adoption date.
- The first history entry records the adoption: what was replaced, where the
  archive is, what was dropped, and the alternatives rejected.
- A project rule that names another file as memory overrides the playbook
  and keeps the log growing. Remove it in the same handoff.

## Memory

A memory records the current position on its topic. When the position
changes, overwrite the memory in place; do not append an update. The index
line changes with it.

## Reading

A new session reads the snapshot and nothing else from these folders until a
question needs history. Search history by filename and first line before
opening any body.
