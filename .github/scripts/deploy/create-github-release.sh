#!/bin/bash

set -euo pipefail

version="$(jq -r .version package.json)"

# Release notes are the top-most CHANGELOG section: everything after the first
# version heading and before the next one.
notes="$(awk '/^#+ \[?[0-9]/ { if (seen++) exit; next } seen' CHANGELOG.md)"

gh release create "v$version" \
  --title "Release $version" \
  --notes "$notes" \
  --target "$GITHUB_SHA"
