# aha-playbook

Engineering, design, and project practices, as installable Claude Code and
Codex plugins. Both use the same skills and working agreements.

## Install on a new machine

Clone once, then run the installer for each harness you use:

```bash
git clone git@github.com:codingfunc/aha-playbook.git
cd aha-playbook
```

### Claude Code

```bash
scripts/install.sh
```

Or without cloning:

```bash
claude plugin marketplace add codingfunc/aha-playbook
claude plugin install playbook-core@aha-playbook
claude plugin install playbook-eng@aha-playbook
```

Restart Claude Code afterwards.

### Codex

Requires Codex CLI with `codex plugin` and `/hooks` support, plus Bash.
The local installation flow was verified with `codex-cli 0.153.4`.

```bash
scripts/install-codex.sh --dry-run
scripts/install-codex.sh
```

The installer registers this checkout as the `aha-playbook` marketplace,
then installs and enables all four plugins for the current Codex user. They
are available when working in other projects as well. Run the installer
again to refresh installed copies from this checkout.

After installing, open `/hooks` in Codex CLI. Review and trust the
`playbook-core` and `playbook-eng` SessionStart hooks, then start a new
conversation. Installing a plugin does not trust its hooks; the always-on
rules will not load until the hooks are trusted. Changed hook definitions
need review again. See the [Codex hook guide](https://learn.chatgpt.com/docs/hooks).

The installer is intended for local Codex CLI and desktop use. Ordinary
ChatGPT does not run plugin hooks, and the IDE extension does not support
plugins. Those surfaces do not provide the same behavior through this
installation. See [supported plugin surfaces](https://learn.chatgpt.com/docs/plugins)
and [Claude plugin compatibility](https://developers.openai.com/plugins/guides/submit-claude-plugin).

Codex also provides `/import` for migrating an existing Claude Code setup.
It is optional here: this repository supplies native packaging for both
harnesses. See the [import guide](https://learn.chatgpt.com/docs/import).

## What is in it

| Plugin | Contents |
| --- | --- |
| `playbook-core` | Domain-neutral working agreement, injected into every session |
| `playbook-eng` | Engineering gates and 12 skills: six engineering practices, three Dart and Flutter skills, two Swift skills, and quality-check |
| `playbook-design` | UI and UX practices (empty; grows as practices are decided) |
| `playbook-projects` | Non-software project practices (empty) |

## How it is structured

```text
.claude-plugin/marketplace.json       Claude marketplace
.agents/plugins/marketplace.json      Codex marketplace
plugins/<plugin>/
  .claude-plugin/plugin.json          Claude manifest
  .codex-plugin/plugin.json           Codex manifest
  skills/<skill>/SKILL.md             Shared skills, loaded on demand
  hooks/kernel.md                    Shared always-on rules, where present
  hooks/hooks.json                    Shared SessionStart configuration
  hooks/session-start                 Shared context emitter
scripts/install.sh                    Claude installer
scripts/install-codex.sh              Codex installer for this checkout
```

Each marketplace points to the same `plugins/` directories. Each skill is
maintained once. The design and projects plugins remain empty until their
practices are decided.

Rules that must always fire live in a `SessionStart` hook kernel — one per
plugin, written as prose in `hooks/kernel.md`. Reference material lives in
skills, which load on demand.

Codex discovers `hooks/hooks.json` automatically. It supports the existing
`CLAUDE_PLUGIN_ROOT` variable and the hook's JSON `additionalContext` output.
The `startup|resume|clear|compact` matcher reloads the rules at those session
boundaries. See [plugin packaging](https://developers.openai.com/plugins/build/plugins).

The dividing line: **a kernel rule is a gate** that changes whether work
proceeds. **A skill is reference material** consulted while doing the work.
Kernel text is a cost paid in every session, so new material goes to a skill
unless it is genuinely a gate.

The two hook invocations read and escape their respective kernel files:
work and memory are proportional to the kernel sizes, with no network calls.
Skill bodies load only when needed. `AGENTS.md` explains how to maintain this
repository; it does not install the playbook into other projects.

## Quality check

- Claude Code: `/playbook-eng:quality-check`
- Codex: select `playbook-eng:quality-check` in the skill picker, or invoke
  `$playbook-eng:quality-check`.

Both run `plugins/playbook-eng/skills/quality-check/SKILL.md`. It reviews
staged and unstaged changes and reports findings without editing files.

## Adding a practice

1. Decide whether it is a gate or reference material.
2. Reference material: create `plugins/<plugin>/skills/<name>/SKILL.md` with
   `name` and `description` frontmatter only.
3. A gate: add it to that plugin's `hooks/kernel.md`.
4. Validate the Claude plugin and its skills:

   ```bash
   claude plugin validate plugins/<plugin> --strict
   claude plugin validate plugins/<plugin>/skills --strict
   ```

5. Validate the Codex manifest with the Plugin Creator skill's
   `scripts/validate_plugin.py`, then install locally and confirm skill and
   hook discovery. Its validator requires Python with PyYAML.
6. Obtain implementation review before adding tests, and explicit approval
   before committing or pushing, as required by the working agreement.

Skill frontmatter is deliberately limited to `name` and `description` so the
skills remain usable by other agent harnesses. Keep harness-specific
metadata in that harness's manifest or adapter, and point new harness
packaging at the existing skill directories.

## Updating

For Claude marketplace installations:

```bash
claude plugin update playbook-core
claude plugin update playbook-eng
```

For Codex installations from this checkout, update the checkout and rerun:

```bash
scripts/install-codex.sh
```

Codex uses installed copies in its plugin cache; changing a source file
alone does not update an installed copy. Start a new conversation after
reinstalling. Use `/hooks` to review any changed hook definitions.

Both manifests carry a semver `version`. Keep the version aligned between
Claude and Codex and bump it per release. A shared content change belongs
in a single release for both harnesses.

## Design and plan

- `docs/specs/2026-08-27-aha-playbook-design.md`
- `docs/plans/2026-08-27-aha-playbook.md`
