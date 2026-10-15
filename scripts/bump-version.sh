#!/usr/bin/env bash
# Set the repo-wide release version in every plugin manifest.
# Usage: scripts/bump-version.sh <semver>
#
# The playbook has one version. Every plugin's Claude and Codex manifest
# carries the same number, and a release bumps all of them together.

set -euo pipefail

if [ $# -ne 1 ] || ! [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Usage: $0 <major.minor.patch>" >&2
  exit 64
fi

VERSION="$1"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

for manifest in "$ROOT"/plugins/*/.claude-plugin/plugin.json \
                "$ROOT"/plugins/*/.codex-plugin/plugin.json; do
  sed -i '' -E "s/(\"version\": *\")[^\"]+(\")/\1${VERSION}\2/" "$manifest"
  echo "${manifest#"$ROOT"/}: $(grep -o '"version": *"[^"]*"' "$manifest")"
done
