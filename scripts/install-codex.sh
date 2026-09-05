#!/usr/bin/env bash
# Install Codex plugins from this checkout.
# Usage: scripts/install-codex.sh [--dry-run]

set -euo pipefail

MARKETPLACE="aha-playbook"
SOURCE="$(cd "$(dirname "$0")/.." && pwd)"
PLUGINS=(playbook-core playbook-eng playbook-design playbook-projects)

DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --help|-h) echo "Usage: scripts/install-codex.sh [--dry-run]"; exit 0 ;;
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

if [ "$DRY_RUN" -eq 1 ]; then
  echo "Dry run complete; no Codex configuration changed."
else
  echo "Installed all four plugins for this Codex user."
  echo "In Codex CLI, open /hooks and review and trust the two playbook hooks."
  echo "Start a new conversation after trusting the hooks to load the rules."
fi
