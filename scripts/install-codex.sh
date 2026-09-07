#!/usr/bin/env bash
# Install Codex plugins from this checkout.
# Usage: scripts/install-codex.sh [--dry-run] [--cheap-agents]
#
# --cheap-agents installs user-level explorer and reader agents pinned to a
# cheaper model with low reasoning effort, so exploration and bulk reads do
# not run at the main session's model.

set -euo pipefail

MARKETPLACE="aha-playbook"
SOURCE="$(cd "$(dirname "$0")/.." && pwd)"
PLUGINS=(playbook-core playbook-eng playbook-design playbook-projects)
AGENT_SRC="${SOURCE}/scripts/codex-agents"
AGENT_DST="${CODEX_HOME:-${HOME}/.codex}/agents"
AGENTS=(explorer reader)

DRY_RUN=0
CHEAP_AGENTS=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --cheap-agents) CHEAP_AGENTS=1 ;;
    --help|-h) echo "Usage: scripts/install-codex.sh [--dry-run] [--cheap-agents]"; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 64 ;;
  esac
done

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf 'DRY RUN:'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

if [ "$DRY_RUN" -eq 0 ] && ! command -v codex >/dev/null 2>&1; then
  echo "Codex CLI is required: https://developers.openai.com/codex/cli" >&2
  exit 69
fi

run codex plugin marketplace add "$SOURCE"
for p in "${PLUGINS[@]}"; do
  run codex plugin add "${p}@${MARKETPLACE}"
done

if [ "$CHEAP_AGENTS" -eq 1 ]; then
  run mkdir -p "$AGENT_DST"
  for a in "${AGENTS[@]}"; do
    src="${AGENT_SRC}/${a}.toml"
    dst="${AGENT_DST}/${a}.toml"
    if [ -f "$dst" ] && ! cmp -s "$src" "$dst"; then
      echo "Skipping $a agent: $dst exists and differs." >&2
      echo "Compare it with $src and replace it by hand if wanted." >&2
    else
      echo "Installing $a agent to $dst"
      run cp "$src" "$dst"
    fi
  done
fi

if [ "$DRY_RUN" -eq 1 ]; then
  echo "Dry run complete; no Codex configuration changed."
else
  echo "Installed all four plugins for this Codex user."
  echo "In Codex CLI, open /hooks and review and trust the two playbook hooks."
  echo "Start a new conversation after trusting the hooks to load the rules."
fi
