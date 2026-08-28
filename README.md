# aha-playbook

Engineering, design, and project practices, as installable Claude Code plugins.

## Install on a new machine

```bash
git clone git@github.com:codingfunc/aha-playbook.git
cd aha-playbook
scripts/install.sh
```

Or without cloning:

```bash
claude plugin marketplace add codingfunc/aha-playbook
claude plugin install playbook-core@aha-playbook
claude plugin install playbook-eng@aha-playbook
```

Restart Claude Code afterwards.

## What is in it

| Plugin | Contents |
| --- | --- |
| `playbook-core` | Domain-neutral working agreement, injected into every session |
| `playbook-eng` | Engineering gates, six practice skills, three Dart and Flutter skills, one command |
| `playbook-design` | UI and UX practices (empty; grows as practices are decided) |
| `playbook-projects` | Non-software project practices (empty) |

## How it is structured

Rules that must always fire live in a `SessionStart` hook kernel — one per
plugin, written as prose in `hooks/kernel.md`. Reference material lives in
skills, which load on demand.

The dividing line: **a kernel rule is a gate** that changes whether work
proceeds. **A skill is reference material** consulted while doing the work.
Kernel text is a cost paid in every session, so new material goes to a skill
unless it is genuinely a gate.

## Adding a practice

1. Decide whether it is a gate or reference material.
2. Reference material: create `plugins/<plugin>/skills/<name>/SKILL.md` with
   `name` and `description` frontmatter only.
3. A gate: add it to that plugin's `hooks/kernel.md`.
4. Run `claude plugin validate plugins/<plugin> --strict`.
5. Commit.

Skill frontmatter is deliberately limited to `name` and `description` so the
skills remain usable by other agent harnesses. Claude Code specific fields
belong in commands and hooks.

## Updating

```bash
claude plugin update playbook-core
claude plugin update playbook-eng
```

Manifests carry a semver `version`, bumped per release.

## Design and plan

- `docs/specs/2026-08-27-aha-playbook-design.md`
- `docs/plans/2026-08-27-aha-playbook.md`
