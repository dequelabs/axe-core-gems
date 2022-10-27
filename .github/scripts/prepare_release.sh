#!/bin/bash

# Fail on first error.
set -e

releaseLevel="$1"

oldVersion="$(node -pe 'require("./package.json").version')"
npx standard-version --release-as "$releaseLevel"
newVersion="$(node -pe 'require("./package.json").version')"

sed -i -e "s/  VERSION\\s*=\\s*\"$oldVersion\"/  VERSION = \"$newVersion\"/" version.rb
