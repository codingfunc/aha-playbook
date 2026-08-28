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
