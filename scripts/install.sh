#!/usr/bin/env bash
# Install the aha-playbook plugins on this machine.
# Usage: scripts/install.sh [--dry-run] [--local] [--explore-haiku]
#
# --explore-haiku installs a user-level Explore agent pinned to Haiku, so
# built-in exploration stops billing at the main session's model.

set -euo pipefail

MARKETPLACE="aha-playbook"
SOURCE="codingfunc/aha-playbook"
PLUGINS=(playbook-core playbook-eng playbook-design playbook-projects)
EXPLORE_SRC="$(cd "$(dirname "$0")" && pwd)/user-agents/explore.md"
EXPLORE_DST="${CLAUDE_CONFIG_DIR:-${HOME}/.claude}/agents/explore.md"

DRY_RUN=0
EXPLORE=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --local)   SOURCE="$(cd "$(dirname "$0")/.." && pwd)" ;;
    --explore-haiku) EXPLORE=1 ;;
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

if [ "$EXPLORE" -eq 1 ]; then
  if [ -f "$EXPLORE_DST" ] && ! cmp -s "$EXPLORE_SRC" "$EXPLORE_DST"; then
    echo "Skipping Explore override: $EXPLORE_DST exists and differs." >&2
    echo "Compare it with $EXPLORE_SRC and replace it by hand if wanted." >&2
  else
    echo "Installing Explore override to $EXPLORE_DST"
    run mkdir -p "$(dirname "$EXPLORE_DST")"
    run cp "$EXPLORE_SRC" "$EXPLORE_DST"
  fi
fi

echo
echo "Done. Restart Claude Code to load the plugins."
echo "All four plugins are enabled at user scope by default."
echo "To scope a domain plugin to one project, disable it at user scope and"
echo "enable it in that project's .claude/settings.json instead."
