# playbook-design

UI and UX design practices.

Includes the `ux-design` skill, which produces a design brief for a consumer
mobile app screen or flow, justified against a named comparison set and the
platform's conventions, and the `accessibility` skill for interface design
and review, with a supporting reference for SwiftUI implementation and
verification. Claude Code and Codex load the same skill directories.

To add one: create `skills/<name>/SKILL.md` with `name` and `description`
frontmatter only, then commit. No manifest change is needed — `skills/` is
auto-discovered.
