# aha-playbook — for agent harnesses

The practice content in this repo is shared. Each harness has its own packaging.

## Portable

Every `plugins/*/skills/*/SKILL.md` follows the Agent Skills spec: a markdown
body with `name` and `description` frontmatter, and nothing else. These are
consumable by Codex, Cursor, Gemini, OpenCode, and any harness that reads the
spec. Point your harness at the `skills/` directories directly.

The always-on rules are in `plugins/playbook-core/hooks/kernel.md` and
`plugins/playbook-eng/hooks/kernel.md`. They are plain markdown. A harness
without a session-start hook should load them the way it loads any
always-on instruction file.

## Harness packaging

- Claude Code: `.claude-plugin/marketplace.json` at the repo root and
  `.claude-plugin/plugin.json` in each plugin. A plugin's `agents/` directory
  holds Claude Code subagents; their frontmatter is harness-specific and is
  not part of the portable skill content.
- Codex: `.agents/plugins/marketplace.json` at the repo root and
  `.codex-plugin/plugin.json` in each plugin. Skill paths point to the same
  `skills/` directories Claude uses.
- The existing `hooks/hooks.json` and `hooks/session-start` files are shared
  by Claude Code and Codex. Codex supports the hook's SessionStart events,
  JSON context output, and `CLAUDE_PLUGIN_ROOT` compatibility variable.
  Codex users must review and trust the hooks before they run.
- There is no `commands/` directory. Claude Code exposes every skill as a
  slash command, and a skill shadows a command of the same name, so the
  quality-check workflow lives only in `skills/quality-check/SKILL.md`.

The installers register the plugins for use across projects. This `AGENTS.md`
describes maintaining the playbook; it does not install it into other repos.

Keep names and release versions aligned between the two plugin manifests.
Preserve `name` and `description` as the only skill frontmatter fields.

## Adding harness support

Add a manifest for your harness at the repo root pointing at the same
`skills/` directories. Do not fork or duplicate the skill content.
