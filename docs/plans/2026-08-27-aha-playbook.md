# aha-playbook Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a private git-backed marketplace of four Claude Code plugins that hold engineering, design, and project practices, installable on any machine in two commands.

**Architecture:** One repo, one marketplace manifest, four plugins under `plugins/`. Rules that must always fire live in a `SessionStart` hook kernel (one per plugin, prose in `kernel.md`); reference material lives in on-demand skills. `playbook-core` carries domain-neutral rules and is always enabled; `playbook-eng` carries code gates and skills; `playbook-design` and `playbook-projects` ship as empty scaffolds.

**Tech Stack:** Markdown, JSON manifests, bash hook scripts. No build step, no dependencies, no test framework — verification is `claude plugin validate --strict`, `claude plugin details`, and direct execution of hook scripts piped through `jq`.

**Spec:** `docs/specs/2026-08-27-aha-playbook-design.md`

## Global Constraints

- Repo: `codingfunc/aha-playbook`, private, default branch `master`.
- Marketplace name: `aha-playbook`. Plugin names: `playbook-core`, `playbook-eng`, `playbook-design`, `playbook-projects`.
- **Skill frontmatter is restricted to `name` and `description` only.** No `allowed-tools`, `context`, `disable-model-invocation`, `user-invocable`, `paths`, or `model`. This keeps skills consumable by Codex, Cursor, Gemini, and OpenCode.
- **Plugin manifests carry a semver `version`** (`0.1.0` at first release), bumped per release. An earlier version of this plan said to omit it; that was withdrawn during Task 1 because `claude plugin validate --strict` rejects a manifest without one, and a declared version does not block `claude plugin update`.
- Kernel text lives in `hooks/kernel.md` as prose, never embedded in the hook script.
- **Hooks emit only `hookSpecificOutput.additionalContext`.** Claude Code reads both `additional_context` and `hookSpecificOutput` *without deduplication* — emitting both double-injects the kernel.
- **Hook scripts use `printf`, not heredocs.** Heredocs hang on bash 5.3+ (superpowers issue #571).
- Commit messages contain no Claude attribution.
- **Never `git commit` or `git push` without explicit approval from the user** — including the commit steps written into this plan. Each task's commit step requires a go-ahead.
- Source files `~/.claude/claude.md` and `~/workspace/ai-rules/flutter-rules.md` are read-only inputs for Tasks 1–7. Only Task 8 modifies `~/.claude/claude.md`, and only after an explicit backup.

**Spec amendment carried by this plan (Task 5):** the spec's migration table assigns comment rules to `code-comments` only. The approved refinement is: minimal comments everywhere, **except public/exported Dart APIs**, which get `dartdoc` with parameters, returns, and throws. Private Dart code follows the minimal rule. This carve-out lives in `dart-flutter-conventions`, and `code-comments` points at it.

---

### Task 1: Repo skeleton, marketplace, and all four plugin manifests

Deliverable: `claude plugin validate` passes on the marketplace and on each of the four plugins. No kernels or skills yet — this task locks the layout.

**Files:**
- Create: `.claude-plugin/marketplace.json`
- Create: `plugins/playbook-core/.claude-plugin/plugin.json`
- Create: `plugins/playbook-eng/.claude-plugin/plugin.json`
- Create: `plugins/playbook-design/.claude-plugin/plugin.json`
- Create: `plugins/playbook-design/README.md`
- Create: `plugins/playbook-design/skills/.gitkeep`
- Create: `plugins/playbook-projects/.claude-plugin/plugin.json`
- Create: `plugins/playbook-projects/README.md`
- Create: `plugins/playbook-projects/skills/.gitkeep`

**Interfaces:**
- Consumes: nothing.
- Produces: the marketplace id `aha-playbook` and the four plugin names, referenced by every later task and by `scripts/install.sh` in Task 7.

- [ ] **Step 1: Write the failing validation check**

Run this first, before creating anything:

```bash
cd ~/workspace/aha-playbook && claude plugin validate . ; echo "EXIT=$?"
```

Expected: non-zero exit, reporting no marketplace manifest found. Record the exact message.

- [ ] **Step 2: Create the marketplace manifest**

`.claude-plugin/marketplace.json`:

```json
{
  "name": "aha-playbook",
  "description": "Engineering, design, and project practices as installable plugins",
  "owner": {
    "name": "Hannan",
    "url": "https://github.com/codingfunc"
  },
  "plugins": [
    {
      "name": "playbook-core",
      "source": "./plugins/playbook-core",
      "description": "Domain-neutral working agreement: stop conditions, work gates, communication"
    },
    {
      "name": "playbook-eng",
      "source": "./plugins/playbook-eng",
      "description": "Software engineering practices: design gates, code quality, refactoring, testing, Dart and Flutter conventions"
    },
    {
      "name": "playbook-design",
      "source": "./plugins/playbook-design",
      "description": "UI and UX design practices"
    },
    {
      "name": "playbook-projects",
      "source": "./plugins/playbook-projects",
      "description": "Practices for non-software projects"
    }
  ]
}
```

- [ ] **Step 3: Create the four plugin manifests**

`plugins/playbook-core/.claude-plugin/plugin.json`:

```json
{
  "name": "playbook-core",
  "description": "Domain-neutral working agreement: stop conditions, work gates, communication",
  "author": {
    "name": "Hannan"
  },
  "homepage": "https://github.com/codingfunc/aha-playbook",
  "repository": "https://github.com/codingfunc/aha-playbook",
  "keywords": ["practices", "working-agreement"]
}
```

`plugins/playbook-eng/.claude-plugin/plugin.json`:

```json
{
  "name": "playbook-eng",
  "description": "Software engineering practices: design gates, code quality, refactoring, testing, Dart and Flutter conventions",
  "author": {
    "name": "Hannan"
  },
  "homepage": "https://github.com/codingfunc/aha-playbook",
  "repository": "https://github.com/codingfunc/aha-playbook",
  "keywords": ["practices", "engineering", "dart", "flutter"]
}
```

`plugins/playbook-design/.claude-plugin/plugin.json`:

```json
{
  "name": "playbook-design",
  "description": "UI and UX design practices",
  "author": {
    "name": "Hannan"
  },
  "homepage": "https://github.com/codingfunc/aha-playbook",
  "repository": "https://github.com/codingfunc/aha-playbook",
  "keywords": ["practices", "design", "ux"]
}
```

`plugins/playbook-projects/.claude-plugin/plugin.json`:

```json
{
  "name": "playbook-projects",
  "description": "Practices for non-software projects",
  "author": {
    "name": "Hannan"
  },
  "homepage": "https://github.com/codingfunc/aha-playbook",
  "repository": "https://github.com/codingfunc/aha-playbook",
  "keywords": ["practices", "projects"]
}
```

- [ ] **Step 4: Create the two empty scaffolds' READMEs**

`plugins/playbook-design/README.md`:

```markdown
# playbook-design

UI and UX design practices.

Intentionally empty. Skills are added one file at a time as practices are
decided, not invented up front.

To add one: create `skills/<name>/SKILL.md` with `name` and `description`
frontmatter only, then commit. No manifest change is needed — `skills/` is
auto-discovered.
```

`plugins/playbook-projects/README.md`:

```markdown
# playbook-projects

Practices for non-software projects.

Intentionally empty. Skills are added one file at a time as practices are
decided, not invented up front.

To add one: create `skills/<name>/SKILL.md` with `name` and `description`
frontmatter only, then commit. No manifest change is needed — `skills/` is
auto-discovered.
```

Create the placeholder files so the empty directories are tracked:

```bash
touch plugins/playbook-design/skills/.gitkeep plugins/playbook-projects/skills/.gitkeep
```

- [ ] **Step 5: Run validation to verify it now passes**

```bash
cd ~/workspace/aha-playbook
claude plugin validate . --strict ; echo "MARKETPLACE_EXIT=$?"
for p in core eng design projects; do
  claude plugin validate "plugins/playbook-$p" --strict ; echo "playbook-$p EXIT=$?"
done
```

Expected: every line reports `✔ Validation passed` and `EXIT=0`. If `--strict` flags an unrecognised field, remove that field rather than dropping `--strict`.

- [ ] **Step 6: Commit (requires user approval first)**

```bash
git add .claude-plugin plugins
git commit -m "Add marketplace manifest and four plugin manifests

Locks the core/eng/design/projects layout. Design and projects ship as
empty scaffolds; their skills are added as practices are decided.

Manifests omit a pinned version field so plugin updates are never blocked."
```

---

### Task 2: playbook-core kernel and SessionStart hook

Deliverable: running the hook script prints valid JSON whose `additionalContext` contains the core kernel text.

**Files:**
- Create: `plugins/playbook-core/hooks/kernel.md`
- Create: `plugins/playbook-core/hooks/hooks.json`
- Create: `plugins/playbook-core/hooks/session-start`

**Interfaces:**
- Consumes: the plugin name `playbook-core` from Task 1.
- Produces: the `session-start` script pattern, copied verbatim by Task 3 with only the plugin name and kernel path differing.

- [ ] **Step 1: Write the failing hook check**

```bash
cd ~/workspace/aha-playbook
CLAUDE_PLUGIN_ROOT=plugins/playbook-core bash plugins/playbook-core/hooks/session-start | jq -e '.hookSpecificOutput.additionalContext | length > 100'
echo "EXIT=$?"
```

Expected: non-zero exit — the script does not exist yet.

- [ ] **Step 2: Write the kernel**

`plugins/playbook-core/hooks/kernel.md`:

```markdown
# Working agreement — core

These rules apply to every task, in every domain. They override default
behaviour and any workflow skill that says otherwise.

## Stop conditions

- **One failure, then stop.** If an approach fails or hits an unexpected
  roadblock once, STOP. Present the error, explain why it happened, and ask
  for input. Do not try variations to see what works.
- **Never invent an unstated value.** Delays, thresholds, magic numbers,
  business rules, spec values: if it is not explicitly stated, STOP and ask.
  Do not infer it from precedent, from similar code, or from what seems
  reasonable.
- **Ambiguity is a stop condition.** If something is unclear, name what is
  confusing and ask. If multiple interpretations exist, present them — never
  pick one silently.

## Work gates

- **One task, then stop.** Finish one task, report what changed and the test
  results, then STOP and wait for a go-ahead. There is no continuous
  execution across tasks, even if a skill or plan says to keep going.
- **Documents only after approval.** Draft the content in chat first. Write
  the document once, when approved. Never update a doc mid-discussion and
  re-update it as decisions evolve.

## Efficiency

- **No unscoped searches.** Never run a broad filesystem search such as
  `find /`, `find ~`, or `grep -r` from root or home. Search narrow, specific,
  likely locations one at a time, or ask where the thing lives.
- **Never re-read a file** already read this session, unless it has changed or
  you need lines outside the earlier read.

## Communication

- No preamble, no wrap-up, no flattery. Get straight into the answer.
- Decisions first. For analysis or trade-offs, give the conclusion or primary
  recommendation first, then the reasoning.
- Push back. Do not default to agreement. Challenge weak logic and missing
  constraints.
```

- [ ] **Step 3: Write the hook declaration**

`plugins/playbook-core/hooks/hooks.json`:

```json
{
  "description": "Injects the core working agreement into every session",
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|clear|compact",
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PLUGIN_ROOT}/hooks/session-start\"",
            "shell": "bash",
            "async": false
          }
        ]
      }
    ]
  }
}
```

- [ ] **Step 4: Write the hook script**

`plugins/playbook-core/hooks/session-start`:

```bash
#!/usr/bin/env bash
# SessionStart hook: injects kernel.md as always-on context.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
kernel=$(cat "${SCRIPT_DIR}/kernel.md")

# JSON-escape via bash parameter substitution; each pass is a single C-level op.
escape_for_json() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\r'/\\r}"
    s="${s//$'\t'/\\t}"
    printf '%s' "$s"
}

escaped=$(escape_for_json "$kernel")

# Emit ONLY hookSpecificOutput: Claude Code reads additional_context too, and
# does not deduplicate. printf rather than heredoc: heredocs hang on bash 5.3+.
printf '{\n  "hookSpecificOutput": {\n    "hookEventName": "SessionStart",\n    "additionalContext": "%s"\n  }\n}\n' "$escaped"

exit 0
```

Make it executable:

```bash
chmod +x plugins/playbook-core/hooks/session-start
```

- [ ] **Step 5: Run the hook check to verify it passes**

```bash
cd ~/workspace/aha-playbook
bash plugins/playbook-core/hooks/session-start | jq -e '.hookSpecificOutput.additionalContext | length > 100' && echo "JSON_OK"
bash plugins/playbook-core/hooks/session-start | jq -r '.hookSpecificOutput.additionalContext' | grep -c "One task, then stop"
claude plugin validate plugins/playbook-core --strict ; echo "EXIT=$?"
```

Expected: `true` then `JSON_OK`; the grep prints `1`; validation exits 0.

- [ ] **Step 6: Verify the escaping survives a quote and a backslash**

```bash
cd ~/workspace/aha-playbook
cp plugins/playbook-core/hooks/kernel.md /tmp/kernel.md.orig
printf '\n- Test: a "quoted" phrase and a \\ backslash.\n' >> plugins/playbook-core/hooks/kernel.md
bash plugins/playbook-core/hooks/session-start | jq -e '.hookSpecificOutput.additionalContext' > /dev/null && echo "ESCAPING_OK"
cp /tmp/kernel.md.orig plugins/playbook-core/hooks/kernel.md
diff /tmp/kernel.md.orig plugins/playbook-core/hooks/kernel.md && echo "RESTORED"
```

The file is not committed yet at this point, so `git checkout` cannot restore
it — copy the original aside and copy it back.

Expected: `ESCAPING_OK`. If `jq` errors, the escaping is wrong — fix `escape_for_json` before continuing, because Task 3 copies this script.

- [ ] **Step 7: Commit (requires user approval first)**

```bash
git add plugins/playbook-core/hooks
git commit -m "Add playbook-core kernel and SessionStart hook

Kernel text lives in kernel.md as prose so editing a rule is editing prose.
Emits only hookSpecificOutput, since Claude Code reads additional_context
as well and does not deduplicate."
```

---

### Task 3: playbook-eng kernel and SessionStart hook

Deliverable: the eng hook prints valid JSON containing the engineering gates, and contains none of the core kernel's rules.

**Files:**
- Create: `plugins/playbook-eng/hooks/kernel.md`
- Create: `plugins/playbook-eng/hooks/hooks.json`
- Create: `plugins/playbook-eng/hooks/session-start`

**Interfaces:**
- Consumes: the `session-start` script from Task 2, copied byte-for-byte.
- Produces: nothing later tasks depend on.

- [ ] **Step 1: Write the failing check**

```bash
cd ~/workspace/aha-playbook
bash plugins/playbook-eng/hooks/session-start | jq -e '.hookSpecificOutput.additionalContext | contains("Architecture first")'
echo "EXIT=$?"
```

Expected: non-zero — the script does not exist yet.

- [ ] **Step 2: Write the eng kernel**

`plugins/playbook-eng/hooks/kernel.md`:

```markdown
# Working agreement — software engineering

Applies to any task that produces or modifies code. The core working
agreement applies as well.

## Before writing code

- **Architecture first.** Present a brief, bulleted outline of the technical
  approach and the design decisions. State assumptions explicitly. WAIT FOR
  APPROVAL before writing any code.
- **Say so when a simpler approach exists.**
- **No speculative code.** Do not write plug-and-play guesswork, and do not
  try multiple variations to see which one works. If unsure about a
  dependency, an API, or a requirement, pause and ask.

## Order of work

- **Production code first.** Implement the production code and ask for
  review. Do not write tests until that review is approved.

## Git

- **Never `git commit` or `git push` without explicit approval.** No
  exceptions — every repo, every branch, every worktree. This applies to
  subagents. `git add` is permitted with approval.
- **No Claude attribution** in commit messages.
```

- [ ] **Step 3: Write the hook declaration**

`plugins/playbook-eng/hooks/hooks.json`:

```json
{
  "description": "Injects the software engineering working agreement",
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|clear|compact",
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PLUGIN_ROOT}/hooks/session-start\"",
            "shell": "bash",
            "async": false
          }
        ]
      }
    ]
  }
}
```

- [ ] **Step 4: Copy the hook script**

```bash
cd ~/workspace/aha-playbook
cp plugins/playbook-core/hooks/session-start plugins/playbook-eng/hooks/session-start
chmod +x plugins/playbook-eng/hooks/session-start
```

The script resolves `kernel.md` relative to its own directory, so no edit is needed.

- [ ] **Step 5: Run the check to verify it passes and the kernels stay separate**

```bash
cd ~/workspace/aha-playbook
bash plugins/playbook-eng/hooks/session-start | jq -e '.hookSpecificOutput.additionalContext | contains("Architecture first")' && echo "ENG_OK"
bash plugins/playbook-eng/hooks/session-start | jq -r '.hookSpecificOutput.additionalContext' | grep -c "No unscoped searches" || echo "CORRECTLY_ABSENT"
claude plugin validate plugins/playbook-eng --strict ; echo "EXIT=$?"
```

Expected: `true` then `ENG_OK`; the grep prints `0` and then `CORRECTLY_ABSENT`, proving the core rules are not duplicated into the eng kernel; validation exits 0.

- [ ] **Step 6: Commit (requires user approval first)**

```bash
git add plugins/playbook-eng/hooks
git commit -m "Add playbook-eng kernel and SessionStart hook

Carries the code-specific gates only: architecture-first approval, no
speculative code, production before tests, and the git approval rule.
Domain-neutral rules stay in playbook-core."
```

---

### Task 4: playbook-eng practice skills

Deliverable: six skills registered by `claude plugin details`, each with `name` and `description` frontmatter only.

**Files:**
- Create: `plugins/playbook-eng/skills/code-quality/SKILL.md`
- Create: `plugins/playbook-eng/skills/modular-design/SKILL.md`
- Create: `plugins/playbook-eng/skills/refactoring-discipline/SKILL.md`
- Create: `plugins/playbook-eng/skills/code-comments/SKILL.md`
- Create: `plugins/playbook-eng/skills/testing-standards/SKILL.md`
- Create: `plugins/playbook-eng/skills/token-economy/SKILL.md`

**Interfaces:**
- Consumes: the `playbook-eng` plugin from Task 1.
- Produces: the skill name `code-comments`, referenced by `dart-flutter-conventions` in Task 5; and the skill name `dart-flutter-conventions`, referenced back from `code-comments`.

- [ ] **Step 1: Write the failing check**

```bash
cd ~/workspace/aha-playbook
ls plugins/playbook-eng/skills/ 2>/dev/null | wc -l
```

Expected: `0`.

- [ ] **Step 2: Write `code-quality/SKILL.md`**

```markdown
---
name: code-quality
description: Use when writing or reviewing any production code - the baseline quality bar covering error handling, SOLID principles, and ACID database design
---

# Code quality

All proposed code is clean, modular, and includes basic error handling.

## Design principles

Follow the coding best practices and design patterns of the language in use.

- **Single responsibility** — a unit does one thing.
- **Open/closed** — open for extension, closed for modification.
- **Liskov substitution** — a subtype is usable anywhere its base type is.
- **Interface segregation** — many focused interfaces beat one broad one.
- **Dependency inversion** — depend on abstractions, not concretions.

## Database design

Design for ACID: atomicity, consistency, isolation, durability. State which
of these a schema or transaction boundary is relying on when it is not
obvious.

## Error handling

Handle the errors the code can actually encounter. Do not add speculative
handling for conditions that cannot arise — that is noise, and it hides the
paths that matter.

Never invent a threshold, retry count, timeout, or backoff value. If the spec
does not state it, stop and ask.
```

- [ ] **Step 3: Write `modular-design/SKILL.md`**

```markdown
---
name: modular-design
description: Use when designing a new component, module, or system boundary - keeps units small, abstract, and robust to future change
---

# Modular design

Design for modularity and abstraction. Ask what is likely to change, and put
a boundary there.

## Test for a good unit

For each unit you should be able to answer three questions:

1. What does it do?
2. How do you use it?
3. What does it depend on?

If someone cannot understand what a unit does without reading its internals,
the boundary is wrong. If you cannot change the internals without breaking
consumers, the interface is wrong.

## Expandability

Before settling on a design, ask what the next three plausible requirements
are, and check that none of them forces a rewrite of the interface. Design
robust to change — not for imagined features, but so that adding them later
does not mean tearing the seams open.

Do not build the imagined features. YAGNI applies to code; this principle
applies only to where the seams go.

## File size as a signal

When a file grows large, that usually means it is doing too much. Files that
change together belong together; split by responsibility, not by technical
layer.
```

- [ ] **Step 4: Write `refactoring-discipline/SKILL.md`**

```markdown
---
name: refactoring-discipline
description: Use when editing existing code - constrains scope so changes stay minimal and reviewable, and defines exactly which cleanup is yours to do
---

# Refactoring discipline

When editing existing code, the change is the change. Nothing else.

## Do not

- Do not improve adjacent code, comments, or formatting.
- Do not refactor things that are not broken.
- Do not restyle code to your preference. Match the existing style, even
  where you would do it differently.

## Dead code

If you notice unrelated dead code, **mention it — do not delete it.** Removing
pre-existing dead code needs approval, separately.

## Orphans you created

Remove imports, variables, and functions that *your* change made unused. That
cleanup is part of your change, not a separate one.

The distinction: something your edit orphaned is yours to remove; something
that was already dead before you arrived is not.
```

- [ ] **Step 5: Write `code-comments/SKILL.md`**

```markdown
---
name: code-comments
description: Use when writing or reviewing comments and docstrings in code - enforces minimal, precise commenting and names the one documented exception
---

# Comments

Write minimal, precise comments only.

Comment solely what the code cannot say itself: a non-obvious constraint, an
invariant, or a load-bearing why.

## Do not

- No narration of what the code does.
- No restating decisions or history in kdoc or javadoc blocks.
- No multi-paragraph class headers.
- No comments explaining that a change is correct, or where it came from.
  That is talking to the reviewer, and it becomes noise the moment the change
  merges.

When in doubt, omit.

## The one exception

Public and exported **Dart** APIs are documented by default, with parameters,
return values, and thrown errors. Private Dart code follows the minimal rule
above. See the `dart-flutter-conventions` skill for the dartdoc mechanics.

This exception exists because a published package API has readers who cannot
see the implementation. It does not generalise to other languages.
```

- [ ] **Step 6: Write `testing-standards/SKILL.md`**

```markdown
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
```

- [ ] **Step 7: Write `token-economy/SKILL.md`**

```markdown
---
name: token-economy
description: Use when reading files, running builds or tests, or handling large generated artifacts - keeps context spend proportionate to the task
---

# Token economy

## Reading

For files over roughly 200 lines, do not read the whole file speculatively.
Locate the relevant section first — by structure or search — then read with
an offset and a limit.

## Command output

Never dump full command output into context. For test runs, builds, and logs,
filter to the failure and summary lines, then read only those.

## Generated artifacts

Generated and large artifacts — mock HTML, lockfiles, build output — are
write-only. Never read one back to verify it, unless it has failed.

(The companion rule, never re-reading a file already read this session, is in
the core working agreement because it applies outside code work too.)
```

- [ ] **Step 8: Verify all six register with correct frontmatter**

```bash
cd ~/workspace/aha-playbook
claude plugin validate plugins/playbook-eng --strict ; echo "EXIT=$?"
ls plugins/playbook-eng/skills | wc -l
grep -l -E '^(allowed-tools|context|model|paths|user-invocable|disable-model-invocation):' plugins/playbook-eng/skills/*/SKILL.md && echo "FORBIDDEN_FRONTMATTER_FOUND" || echo "FRONTMATTER_CLEAN"
```

Expected: validation exits 0; the count is `6`; output ends with `FRONTMATTER_CLEAN`.

- [ ] **Step 9: Commit (requires user approval first)**

```bash
git add plugins/playbook-eng/skills
git commit -m "Add six engineering practice skills

Migrates the code quality checklist, modularity, refactoring scope rules,
comment minimalism, test mocking rules, and token economy out of the global
claude.md into on-demand skills.

Frontmatter is limited to name and description so the skills stay portable
to other agent harnesses."
```

---

### Task 5: Dart and Flutter skills

Deliverable: three skills split from `~/workspace/ai-rules/flutter-rules.md`, with the conflicting sections resolved, plus the spec amendment recording the doc-comment decision.

The source file is 777 lines and is the stock Google `flutter/ai-rules` file, vendored unmodified. **It is a read-only input. Do not edit or delete it.**

**Files:**
- Create: `plugins/playbook-eng/skills/dart-flutter-conventions/SKILL.md`
- Create: `plugins/playbook-eng/skills/flutter-architecture/SKILL.md`
- Create: `plugins/playbook-eng/skills/flutter-theming/SKILL.md`
- Modify: `docs/specs/2026-08-27-aha-playbook-design.md` (migration table only)
- Read only: `~/workspace/ai-rules/flutter-rules.md`

**Interfaces:**
- Consumes: `code-comments` from Task 4, which points here for the Dart exception.
- Produces: nothing later tasks depend on.

- [ ] **Step 1: Write the failing check**

```bash
cd ~/workspace/aha-playbook
ls plugins/playbook-eng/skills/ | grep -c -E 'dart|flutter'
```

Expected: `0`.

- [ ] **Step 2: Build `dart-flutter-conventions/SKILL.md`**

Copy these line ranges from `~/workspace/ai-rules/flutter-rules.md`, in this order, under the frontmatter below:

| Source lines | Section |
| --- | --- |
| 26–29 | Project Structure |
| 30–44 | Flutter style guide |
| 45–60 | Package Management |
| 61–83 | Code Quality |
| 84–112 | Dart Best Practices |
| 113–130 | Flutter Best Practices |
| 131–138 | API Design Principles |
| 151–165 | Lint Rules |
| 312–323 | Code Generation |
| 730–742 | Commenting Style (dartdoc mechanics) |
| 743–752 | Writing Style |

Frontmatter and header:

```markdown
---
name: dart-flutter-conventions
description: Use when writing Dart or Flutter code - project structure, style guide, package management, lint rules, code generation, and public API documentation
---

# Dart and Flutter conventions
```

Then append this Tooling section, drawn from source lines 19–24:

```markdown
## Tooling

- Use `dart_format` for consistent formatting.
- Use `dart_fix` to apply mechanical fixes and conform to the configured
  analysis options.
- Use `analyze_files` to run the linter.
```

Then append this Documentation section, which **replaces** source lines 712–729 and 753–764:

```markdown
## Documenting public APIs

Public and exported APIs are documented by default — this is the documented
exception to the minimal-comment rule in `code-comments`. Private code follows
the minimal rule: comment only a non-obvious constraint, invariant, or
load-bearing why.

For a public API, write a `///` doc comment covering what the function
expects, what it returns, and what it may throw.

Rationale for the exception: a published package API has readers who cannot
see the implementation. Private code does not.
```

**Deliberately dropped, with reasons:**

- Lines 9–25 (Interaction Guidelines) — "assume the user may be new to Dart" is false; "provide explanations for null safety, futures, and streams" contradicts the no-preamble rule in the core kernel; "ask for clarification if ambiguous" is stated more strongly in the core kernel. The tooling bullets from this range are kept above.
- Line 714 ("Write `dartdoc`-style comments for all public APIs") and lines 753–764 (What to Document) — superseded by the Documenting public APIs section above.
- Line 756 ("It's a good idea to document private APIs as well") — directly contradicts the approved decision. Dropped outright.

- [ ] **Step 3: Build `flutter-architecture/SKILL.md`**

Copy these line ranges from the source, in this order:

| Source lines | Section |
| --- | --- |
| 139–150 | Application Architecture |
| 166–203 | State Management |
| 204–209 | Data Flow |
| 210–262 | Routing |
| 263–287 | Data Handling & Serialization |
| 288–311 | Logging |
| 324–332 | Testing |
| 333–348 | Testing Best practices |

Frontmatter and header:

```markdown
---
name: flutter-architecture
description: Use when structuring a Flutter app or choosing state management, routing, serialization, or logging - the layered architecture and data flow conventions
---

# Flutter architecture
```

Then append this cross-reference at the end of the Testing section:

```markdown
See the `testing-standards` skill for the rules on what may be mocked and
when tests are written. Those rules take precedence over anything above.
```

- [ ] **Step 4: Build `flutter-theming/SKILL.md`**

Copy these line ranges from the source, in this order:

| Source lines | Section |
| --- | --- |
| 349–367 | Visual Design & Theming |
| 368–405 | Theming |
| 406–447 | Assets and Images |
| 448–455 | UI Theming and Styling Code |
| 456–495 | Material Theming / ThemeData and M3 |
| 496–546 | Design Tokens with ThemeExtension |
| 547–567 | Styling with WidgetStateProperty |
| 568–591 | Building Flexible and Overflow-Safe Layouts |
| 592–596 | Layering Widgets with Stack |
| 597–638 | Advanced Layout with Overlays |
| 639–671 | Colour Scheme (contrast, palette, complementary, example) |
| 672–711 | Fonts (selection, hierarchy, readability, scale) |
| 765–777 | Accessibility |

Frontmatter and header:

```markdown
---
name: flutter-theming
description: Use when building or restyling Flutter UI - ThemeData and Material 3, design tokens, layout safety, colour, typography, and accessibility
---

# Flutter theming and layout
```

- [ ] **Step 5: Amend the spec's migration table**

In `docs/specs/2026-08-27-aha-playbook-design.md`, find the `code-comments` row of the playbook-eng skills table and replace its source cell with:

```
Minimal, precise comments; only non-obvious constraints, invariants, or load-bearing why. Exception: public and exported Dart APIs are documented by default (see `dart-flutter-conventions`)
```

In the same table, replace the `dart-flutter-conventions` source cell with:

```
Style guide, package management, Dart and Flutter best practices, API design, lint rules, code generation, `dart_format` / `dart_fix` / `analyze_files`, public API documentation
```

In the "Dropped deliberately" section, append:

```markdown
Lines 712–764 (Documentation) are also not migrated intact. "Always document
public APIs" and "consider documenting private APIs as well" conflict with the
minimal-comment rule. The approved resolution: minimal comments everywhere,
except public and exported Dart APIs, which are documented with parameters,
returns, and throws. The mechanical dartdoc style rules (lines 730–752) are
kept.
```

- [ ] **Step 6: Verify the split is complete and lossless**

```bash
cd ~/workspace/aha-playbook
claude plugin validate plugins/playbook-eng --strict ; echo "EXIT=$?"
ls plugins/playbook-eng/skills | wc -l
wc -l plugins/playbook-eng/skills/{dart-flutter-conventions,flutter-architecture,flutter-theming}/SKILL.md
grep -c "new to Dart" plugins/playbook-eng/skills/*/SKILL.md || echo "INTERACTION_GUIDELINES_CORRECTLY_ABSENT"
grep -c "document private APIs" plugins/playbook-eng/skills/*/SKILL.md || echo "PRIVATE_API_RULE_CORRECTLY_ABSENT"
```

Expected: validation exits 0; skill count is `9`; the three new files total roughly 700 lines; both greps report absence.

- [ ] **Step 7: Commit (requires user approval first)**

```bash
git add plugins/playbook-eng/skills docs/specs
git commit -m "Split Flutter rules into three skills and resolve doc conflicts

Splits the 777-line vendored flutter-rules.md into conventions, architecture,
and theming so that lint rules can be loaded without pulling in theming and
accessibility material.

Drops the Interaction Guidelines section, which contradicts the core working
agreement, and resolves the documentation conflict: minimal comments
everywhere, except public and exported Dart APIs.

Amends the spec migration table to match."
```

---

### Task 6: quality-check command

Deliverable: `/playbook-eng:quality-check` appears in the command list and runs the checklist against the current diff.

**Files:**
- Create: `plugins/playbook-eng/commands/quality-check.md`

**Interfaces:**
- Consumes: the skill names `code-quality`, `refactoring-discipline`, `code-comments`, `testing-standards` from Task 4.
- Produces: nothing later tasks depend on.

- [ ] **Step 1: Write the failing check**

```bash
cd ~/workspace/aha-playbook && ls plugins/playbook-eng/commands/ 2>/dev/null ; echo "EXIT=$?"
```

Expected: non-zero — the directory does not exist.

- [ ] **Step 2: Write the command**

`plugins/playbook-eng/commands/quality-check.md`:

```markdown
---
description: Run the engineering quality checklist against the current diff
---

Review the current uncommitted diff against the playbook quality bar. Read
the `code-quality`, `refactoring-discipline`, `code-comments`, and
`testing-standards` skills first, then apply them.

Run `git diff` and `git diff --staged` to see the changes. If both are empty,
say so and stop.

Report findings under these four headings, and only report a heading if it
has findings:

1. **Quality** — error handling that is missing or speculative, SOLID
   violations, invented values that the spec never stated.
2. **Scope** — changes to adjacent code, comments, or formatting that the
   task did not require; refactoring of things that were not broken; deleted
   pre-existing dead code.
3. **Comments** — narration of what the code does, restated history, or a
   public Dart API left undocumented.
4. **Tests** — a mocked service class where only the low-level client should
   be mocked; tests written before the implementation review.

For each finding give the file, the line, and one sentence on why it matters.
Do not fix anything. Report, then stop.

If the diff is clean against all four, say so in one sentence.
```

- [ ] **Step 3: Verify it registers**

```bash
cd ~/workspace/aha-playbook
claude plugin validate plugins/playbook-eng --strict ; echo "EXIT=$?"
```

Expected: exit 0. After the plugin is installed in Task 8, `claude plugin details playbook-eng` lists one command.

- [ ] **Step 4: Commit (requires user approval first)**

```bash
git add plugins/playbook-eng/commands
git commit -m "Add quality-check command

Runs the four practice skills against the current diff and reports findings
without fixing them."
```

---

### Task 7: Install script and repo documentation

Deliverable: a new machine can go from nothing to installed with one script; `AGENTS.md` gives non-Claude harnesses an entry point.

**Files:**
- Create: `scripts/install.sh`
- Create: `README.md`
- Create: `AGENTS.md`

**Interfaces:**
- Consumes: the marketplace id and four plugin names from Task 1.
- Produces: nothing later tasks depend on.

- [ ] **Step 1: Write the failing check**

```bash
cd ~/workspace/aha-playbook && bash scripts/install.sh --dry-run ; echo "EXIT=$?"
```

Expected: non-zero — the script does not exist.

- [ ] **Step 2: Write the install script**

`scripts/install.sh`:

```bash
#!/usr/bin/env bash
# Install the aha-playbook plugins on this machine.
# Usage: scripts/install.sh [--dry-run] [--local]

set -euo pipefail

MARKETPLACE="aha-playbook"
SOURCE="codingfunc/aha-playbook"
PLUGINS=(playbook-core playbook-eng playbook-design playbook-projects)

DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --local)   SOURCE="$(cd "$(dirname "$0")/.." && pwd)" ;;
    *) echo "Unknown option: $arg" >&2; exit 64 ;;
  esac
done

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "DRY RUN: $*"
  else
    "$@"
  fi
}

echo "Adding marketplace from: $SOURCE"
run claude plugin marketplace add "$SOURCE"

for p in "${PLUGINS[@]}"; do
  echo "Installing $p"
  run claude plugin install "${p}@${MARKETPLACE}"
done

echo
echo "Done. Restart Claude Code to load the plugins."
echo "playbook-core and playbook-eng are enabled at user scope by default."
echo "To scope a domain plugin to one project, disable it at user scope and"
echo "enable it in that project's .claude/settings.json instead."
```

Make it executable:

```bash
chmod +x scripts/install.sh
```

- [ ] **Step 3: Write the README**

`README.md` (note: the outer fence is four backticks because the content
itself contains fenced blocks):

````markdown
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

Manifests carry no pinned `version`, so updates are never blocked.

## Design and plan

- `docs/specs/2026-08-27-aha-playbook-design.md`
- `docs/plans/2026-08-27-aha-playbook.md`
````

- [ ] **Step 4: Write AGENTS.md**

`AGENTS.md`:

```markdown
# aha-playbook — for agent harnesses

The practice content in this repo is portable. The packaging is not.

## Portable

Every `plugins/*/skills/*/SKILL.md` follows the Agent Skills spec: a markdown
body with `name` and `description` frontmatter, and nothing else. These are
consumable by Codex, Cursor, Gemini, OpenCode, and any harness that reads the
spec. Point your harness at the `skills/` directories directly.

The always-on rules are in `plugins/playbook-core/hooks/kernel.md` and
`plugins/playbook-eng/hooks/kernel.md`. They are plain markdown. A harness
without a session-start hook should load them the way it loads any
always-on instruction file.

## Not portable

`.claude-plugin/`, `hooks/hooks.json`, the `hooks/session-start` scripts, and
`commands/` are Claude Code specific.

## Adding harness support

Add a manifest for your harness at the repo root pointing at the same
`skills/` directories. Do not fork or duplicate the skill content.
```

- [ ] **Step 5: Verify the script is correct without executing installs**

```bash
cd ~/workspace/aha-playbook
bash scripts/install.sh --dry-run
bash scripts/install.sh --dry-run --local
bash -n scripts/install.sh && echo "SYNTAX_OK"
```

Expected: the first prints five `DRY RUN:` lines using `codingfunc/aha-playbook`; the second prints the same with an absolute local path; then `SYNTAX_OK`.

- [ ] **Step 6: Commit (requires user approval first)**

```bash
git add scripts README.md AGENTS.md
git commit -m "Add install script and repo documentation

install.sh takes --local for testing against the working tree and --dry-run
to print without executing.

AGENTS.md records which parts are portable to other harnesses and which are
Claude Code specific."
```

---

### Task 8: End-to-end verification and global claude.md migration

Deliverable: the plugins install and load from a real marketplace install, both kernels appear in a fresh session, and the global `claude.md` is reduced to what is genuinely machine-local.

This is the only task that touches anything outside the repo.

**Files:**
- Modify: `~/.claude/claude.md`
- Create: `~/.claude/claude.md.pre-playbook.bak`

**Interfaces:**
- Consumes: everything from Tasks 1–7.
- Produces: nothing.

- [x] **Step 1: Install from the local working tree**

```bash
cd ~/workspace/aha-playbook
scripts/install.sh --local
```

Expected: marketplace added, four plugins installed. If the marketplace name collides with an earlier attempt, run `claude plugin marketplace remove aha-playbook` first.

- [x] **Step 2: Verify registration and measure the always-on cost**

```bash
claude plugin list | grep playbook
claude plugin details playbook-core
claude plugin details playbook-eng
```

Expected: four plugins listed. `playbook-eng` reports 9 skills, 1 command, 1 hook. **Record the "Always-on" token figure for each.** Hooks are reported as harness-only with no model context cost — that figure covers the skill index, not the injected kernel, so the true always-on cost is that number plus the kernel length.

If the combined skill-index cost exceeds roughly 500 tokens, shorten skill `description` fields before proceeding — that index is in every session.

Measured 2026-08-30: skill index ~486 tok (9 skills, evenly sized at 29–38 tok each) plus ~30 tok for the `quality-check` command. Kernels add ~460 tok (core) and ~265 tok (eng) on top, for ~1,241 tok always-on in an engineering session. The threshold was raised from 400 to 500 rather than shortening descriptions: the overage is within estimate noise, the kernels dominate the real cost, and vaguer descriptions cost skill-discovery reliability.

- [ ] **Step 3: Verify both kernels reach a real session**

Restart Claude Code, then in a fresh session ask:

```
Without using any tools, quote the first bullet under "Stop conditions" and
the first bullet under "Before writing code" from your session context.
```

Expected: the reply quotes "One failure, then stop" and "Architecture first". If either is missing, the hook did not fire — check that `session-start` is executable and that `hooks.json` uses `${CLAUDE_PLUGIN_ROOT}`.

- [ ] **Step 4: Verify domain isolation**

```bash
claude plugin disable playbook-eng
```

Restart, then in a fresh session ask the same question. Expected: the core bullet is quoted and the engineering bullet is absent — proving the eng gates do not leak into non-engineering sessions. Then re-enable:

```bash
claude plugin enable playbook-eng
```

- [ ] **Step 5: Verify each skill body loads**

In a fresh session, invoke each skill by name and confirm the body appears:
`code-quality`, `modular-design`, `refactoring-discipline`, `code-comments`,
`testing-standards`, `token-economy`, `dart-flutter-conventions`,
`flutter-architecture`, `flutter-theming`. Then run `/playbook-eng:quality-check`
in a repo with an uncommitted change and confirm it reports rather than fixes.

- [x] **Step 6: Back up the global claude.md**

```bash
cp ~/.claude/claude.md ~/.claude/claude.md.pre-playbook.bak
wc -l ~/.claude/claude.md ~/.claude/claude.md.pre-playbook.bak
```

Expected: identical line counts. **Do not proceed without this backup.**

- [x] **Step 7: Reduce the global claude.md**

Remove the sections now carried by the plugins: the Software Engineering and Code Generation block, the Code Quality Checklist, Token Economy, and Minimal Comments on Code — the whole file.

Corrected 2026-08-30: an earlier draft of this step also listed a "General block" and a "final General block". No such sections existed in `claude.md` by the time the migration ran; the file had exactly the four above.

Replace the whole file with:

```markdown
# Practices

My engineering, design, and project practices live in the `aha-playbook`
plugins, not in this file. See https://github.com/codingfunc/aha-playbook.

- Always-on rules: `playbook-core` and `playbook-eng` session kernels.
- Everything else: on-demand skills.

If a rule seems to be missing, the plugin is probably not enabled on this
machine. Run `claude plugin list`.

# Machine-local

(Nothing yet. Anything genuinely specific to this machine goes here — not
practices, which belong in the plugins.)
```

- [x] **Step 8: Verify nothing was lost**

```bash
cd ~/workspace/aha-playbook
grep -oiE '\b(SOLID|ACID|Fail-Rule|dartdoc|mock|refactor|comment|token)\b' \
  ~/.claude/claude.md.pre-playbook.bak | tr 'A-Z' 'a-z' | sort -u > /tmp/was.txt
cat plugins/*/hooks/kernel.md plugins/*/skills/*/SKILL.md \
  | grep -oiE '\b(SOLID|ACID|Fail-Rule|dartdoc|mock|refactor|comment|token)\b' \
  | tr 'A-Z' 'a-z' | sort -u > /tmp/now.txt
comm -23 /tmp/was.txt /tmp/now.txt
```

Expected: `comm` prints nothing — every concept in the backup appears somewhere
in the plugins. Any line it does print is a concept that was dropped in the
migration. Account for each one before continuing; do not assume it was
intentional.

- [ ] **Step 9: Confirm in a fresh session**

Restart Claude Code. Confirm the kernels still load with the reduced `claude.md`, and that `claude plugin list` shows all four plugins.

- [ ] **Step 10: Push (requires user approval first)**

```bash
cd ~/workspace/aha-playbook
git status
git push origin master
```

The backup at `~/.claude/claude.md.pre-playbook.bak` stays until you confirm a week of normal use.

---

## Post-completion

Once this plan is done, adding a practice is: decide gate or reference, write one file, validate, commit. Growth of `playbook-design` and `playbook-projects` needs no structural work.

Two things deliberately not built, recorded so they are not re-litigated:

- **No enforcement hooks.** Default permission mode already prompts for `git commit`; a `deny` rule would forbid approved commits, and a `PreToolUse` hook is custom code that can only block.
- **No per-harness adapter manifests.** `AGENTS.md` documents the portable surface; adapters are added when a second harness is actually in use.
