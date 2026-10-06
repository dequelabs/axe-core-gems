#!/bin/bash

set -euo pipefail

# `jq -e` fails on a missing key rather than emitting the string "null", which
# would otherwise be published as a gem version.
version="$(jq -er .version package.json)"

if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "package.json version is not X.Y.Z: $version" >&2
  exit 1
fi

echo "$version"
