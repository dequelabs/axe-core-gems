#!/bin/bash

# Fail on first error.
set -e

releaseLevel="$1"

oldVersion="$(node -pe 'require("./package.json").version')"
npx standard-version@"$STD_VERSION_VERSION" --release-as "$releaseLevel" --skip.commit=true --skip.changelog=true --skip.tag=true
newVersion="$(node -pe 'require("./package.json").version')"

sed -i -e "s/  VERSION\\s*=\\s*\"$oldVersion\"/  VERSION = \"$newVersion\"/" version.rb

npx conventional-changelog-cli@"$CHANGELOG_VERSION" -p angular -i CHANGELOG.md -s
