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
if ! run claude plugin marketplace add "$SOURCE"; then
  echo "Marketplace already added, continuing."
fi

for p in "${PLUGINS[@]}"; do
  echo "Installing $p"
  run claude plugin install "${p}@${MARKETPLACE}"
done

echo
echo "Done. Restart Claude Code to load the plugins."
echo "All four plugins are enabled at user scope by default."
echo "To scope a domain plugin to one project, disable it at user scope and"
echo "enable it in that project's .claude/settings.json instead."
