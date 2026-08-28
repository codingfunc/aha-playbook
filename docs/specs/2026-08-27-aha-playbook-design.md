# aha-playbook — Design

Date: 2026-08-27
Status: Approved, not yet implemented

## Purpose

A git-backed, versioned home for engineering, design, and project practices, installable
on any machine as a set of Claude Code plugins.

The driver is portability and accumulation: practices currently live in a single global
`~/.claude/claude.md` that exists on one machine and cannot be versioned, reviewed, or
grown incrementally. After this change, adding a practice is one file plus one commit,
and a new machine is two commands.

Non-goals: team distribution, enforcement tooling, and any UI/UX or non-software rule
content that has not yet been stated.

## Constraints discovered during design

These are verified against the Claude Code docs and shaped the design. They are recorded
here because they are non-obvious and will otherwise be rediscovered.

1. **A plugin cannot ship an always-on `CLAUDE.md`.** Instruction context is available
   only through on-demand skills or a `SessionStart` hook emitting `additionalContext`.
   Any rule that must always apply has to live in a hook.
2. **A plugin cannot ship permission rules.** `allow`/`ask`/`deny` are configurable only
   in user, project, or local `settings.json`. A plugin's settings support only `agent`
   and `subagentStatusLine`.
3. **`deny` is absolute.** It overrides every permission mode and beats a `PreToolUse`
   hook returning `allow`. It cannot be approved interactively.
4. **`ask` forces a prompt** even in `acceptEdits` mode and even when a more specific
   `allow` rule matches.
5. **Default permission mode already prompts** for any non-read Bash command, including
   `git commit`.
6. **The skill index is always-on.** Every enabled skill's `name` and `description` sits
   in context in every session; only skill bodies are lazy. This is the cost that
   justifies splitting by domain.
7. **A plugin gets one `SessionStart` hook**, injected unconditionally wherever the
   plugin is enabled, with no way to vary by project.

## Architecture

### Why multiple plugins

Plugins are enabled per scope — user, project, or machine. Constraints 6 and 7 mean a
single plugin would inject engineering gates ("architecture first, wait for approval
before writing code") into sessions about writing or design work, where those
instructions are not merely wasteful but wrong. Separate plugins let a non-software
project enable `playbook-projects` and never see them.

The cost is a `plugins/` layout, one manifest per plugin, and a one-time enable step per
machine. Accepted.

### Layout

```
aha-playbook/
  .claude-plugin/
    marketplace.json          # name: aha-playbook; lists all four
  plugins/
    playbook-core/
      .claude-plugin/plugin.json
      hooks/
        hooks.json
        session-start         # bash; reads kernel.md, emits additionalContext
        kernel.md             # the always-on rules, as prose
    playbook-eng/
      .claude-plugin/plugin.json
      hooks/{hooks.json,session-start,kernel.md}
      commands/quality-check.md
      skills/<one dir per skill>/SKILL.md
    playbook-design/
      .claude-plugin/plugin.json
      skills/.gitkeep
      README.md
    playbook-projects/
      .claude-plugin/plugin.json
      skills/.gitkeep
      README.md
  scripts/install.sh
  docs/specs/
  AGENTS.md
  README.md
```

Slash namespaces read as `/playbook-eng:code-quality`, `/playbook-design:<skill>`.

### Kernel vs skill

The dividing line: **a kernel rule is a gate** — it changes whether work proceeds, and
must fire without being asked for. **A skill is reference material** — consulted while
doing the work, and safe to load on demand.

Kernels are prose in `kernel.md`, not embedded in the hook script, so editing a rule is
editing prose.

Kernel size is a standing cost paid in every session. Both kernels are capped at roughly
the length of the sections they replace; new material goes to skills by default, and
promoting anything to a kernel is a deliberate decision.

## Content migration

Source: `~/.claude/claude.md` (global) and `~/workspace/ai-rules/flutter-rules.md`.
Nothing is dropped except where noted. Neither source file is modified or deleted by
this work.

### playbook-core kernel — always on, every domain

- 1-Fail-Rule: one unexpected failure or roadblock, stop, explain, ask.
- Never fill in an ambiguous or unstated spec value; stop and ask instead.
- Task review gate: finish one task, report what changed, stop. No continuous execution
  across tasks, regardless of what a skill or plan says.
- Create or update documents only after the content is approved in chat.
- Never run a broad or unscoped filesystem search.
- Never re-read a file already read this session unless it changed.
- Communication: no preamble or wrap-up, decisions first, push back rather than agree.

### playbook-eng kernel — only where enabled

- Architecture first: present a bulleted outline of approach and design decisions, state
  assumptions, wait for approval before writing code.
- Present multiple interpretations rather than silently picking one; say so when a
  simpler approach exists.
- Production code first; tests only after the implementation review is approved.
- No speculative or plug-and-play code; no trying variations to see what works.
- Never `git commit` or `git push` without explicit approval; no Claude attribution in
  commit messages.

### playbook-eng skills — on demand

| Skill | Source |
| --- | --- |
| `code-quality` | Clean, modular, error-handled code; SOLID; ACID for database design |
| `modular-design` | Modularity and abstraction, expandability, robustness to change |
| `refactoring-discipline` | Do not improve adjacent code; match existing style; mention dead code rather than deleting; remove only orphans your own change created |
| `code-comments` | Minimal, precise comments; only non-obvious constraints, invariants, or load-bearing why |
| `testing-standards` | Never mock a service class in integration tests; mock only low-level clients (GraphQL, REST) |
| `token-economy` | Targeted reads over whole files; filter build and test output to failures; treat generated artifacts as write-only |
| `dart-flutter-conventions` | Style guide, package management, Dart and Flutter best practices, API design, lint rules, code generation, `dart_format` / `dart_fix` / `analyze_files` |
| `flutter-architecture` | Layered architecture, state management, data flow, routing, serialization, logging, testing |
| `flutter-theming` | `ThemeData` and Material 3, design tokens via `ThemeExtension`, `WidgetStateProperty`, overflow-safe layout, colour, typography, accessibility |

`flutter-rules.md` is split three ways rather than migrated whole: at 777 lines, a single
skill body would pull theming and accessibility material into context when only the lint
rules were wanted.

### Dropped deliberately

`flutter-rules.md` is the stock Google `flutter/ai-rules` file, vendored unmodified. Its
"Interaction Guidelines" section is not migrated:

- "Assume the user may be new to Dart" — false.
- "Provide explanations for Dart-specific features like null safety, futures, and
  streams" — contradicts the no-preamble rule in the core kernel.
- "If a request is ambiguous, ask for clarification" — the core kernel states this more
  strongly.

The tool guidance in that section (`dart_format`, `dart_fix`, `analyze_files`) is kept
and moves to `dart-flutter-conventions`.

### Empty by design

`playbook-design` and `playbook-projects` ship a manifest, an empty `skills/`, and a
README stating intent. Scaffolding costs nothing and makes the first real skill a
one-commit change; inventing their content now would mean guessing at unstated rules.

## Enforcement

None beyond prose. Considered and rejected:

- A `PreToolUse` hook blocking git writes: custom code to maintain, and it can only
  block, so an approved commit would need an escape hatch.
- A `deny` permission rule: absolute, so it would forbid commits that were approved —
  stricter than the rule it implements, and it cannot ship in the plugin anyway.
- An `ask` permission rule via the install script: semantically exact, but default
  permission mode already prompts for `git commit`, so it earns nothing in normal use.

`scripts/install.sh` therefore only adds the marketplace and installs the plugins; it
does not modify `settings.json`.

## Cross-tool portability

Skill content follows the open Agent Skills spec and is consumable by Codex, Cursor,
Gemini, and OpenCode. Packaging is not portable.

Therefore: **skill frontmatter is restricted to `name` and `description`.** Claude Code
specific fields (`allowed-tools`, `context: fork`, `disable-model-invocation`,
`user-invocable`, `paths`, `model`) are confined to commands and hooks, never to a skill
that is meant to travel.

`AGENTS.md` at the repo root is the cross-harness entry point. Per-harness adapter
manifests can be added later without rewriting content.

## Installation

On a new machine:

```
claude plugin marketplace add codingfunc/aha-playbook
claude plugin install playbook-core@aha-playbook
claude plugin install playbook-eng@aha-playbook
```

`scripts/install.sh` wraps this. `playbook-core` is enabled at user scope; the domain
plugins are enabled at user or project scope as appropriate.

Updates are `claude plugin update`, which pulls from git. Plugin manifests carry a
semver `version`, bumped per release.

This corrects an earlier version of this spec, which said manifests should omit
`version` so that updates were not blocked. That was wrong on two counts:
`claude plugin validate --strict` rejects a manifest without a version, and plugins
that declare one update in place regardless — `superpowers` (6.3.0) and `dart-flutter`
(1.0.1) both do. `claude plugin tag` exists specifically to validate that a plugin's
declared version agrees with its marketplace entry.

## Consequences

- `~/.claude/claude.md` shrinks to a pointer plus genuinely machine-local content. The
  rules stop being a file copied between machines.
- Token-economy rules 2 through 4 become on-demand and stop applying by default. Rule 1
  is promoted to the core kernel. Accepted trade-off.
- Two sources of truth exist until the global file is trimmed. Trimming it is part of
  implementation, not a follow-up.

## Verification

Before this is called done:

- All four plugins register from a local-path marketplace install.
- Both kernels appear in a fresh session's context.
- Every skill body loads when invoked.
- `/playbook-eng:quality-check` runs.
- A session with only `playbook-core` enabled shows no engineering gates.

Evidence is shown, not asserted.
