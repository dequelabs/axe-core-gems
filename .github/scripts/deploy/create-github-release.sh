#!/bin/bash

set -euo pipefail

version="$("$(dirname "$0")/read-version.sh")"

# Release notes are the top-most CHANGELOG section: everything after the first
# version heading and before the next one.
heading="$(awk '/^#+ \[?[0-9]/ { print; exit }' CHANGELOG.md)"
notes="$(awk '/^#+ \[?[0-9]/ { if (seen++) exit; next } seen' CHANGELOG.md)"

# Guard against publishing the previous release's notes, or none at all, when
# CHANGELOG.md was not regenerated for this version.
if [[ "$heading" != *"$version"* ]]; then
  echo "top CHANGELOG.md heading does not name $version: ${heading:-<none>}" >&2
  exit 1
fi

if [ -z "${notes//[[:space:]]/}" ]; then
  echo "no release notes found in CHANGELOG.md for $version" >&2
  exit 1
fi

gh release create "v$version" \
  --title "Release $version" \
  --notes "$notes" \
  --target "${GITHUB_SHA:?GITHUB_SHA must name the commit to tag}"
