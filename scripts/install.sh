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

# Skip the add when the marketplace is already registered, rather than running it
# and ignoring the failure — ignoring it would also swallow a bad source, a network
# error, or an auth failure, and the installs below would then run against a
# marketplace that was never registered.
if claude plugin marketplace list 2>/dev/null | grep -qw "$MARKETPLACE"; then
  echo "Marketplace $MARKETPLACE already registered, skipping add."
else
  echo "Adding marketplace from: $SOURCE"
  run claude plugin marketplace add "$SOURCE"
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
