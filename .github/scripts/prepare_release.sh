#!/bin/bash

# Fail on first error.
set -e

releaseLevel="$1"

oldVersion="$(node -pe 'require("./package.json").version')"

# If no release level is specified, let commit-and-tag-version handle versioning
if [ -z "$releaseLevel" ] 
then
  npx commit-and-tag-version --skip.commit=true --skip.changelog=true --skip.tag=true
else
  npx commit-and-tag-version --release-as "$releaseLevel" --skip.commit=true --skip.changelog=true --skip.tag=true
fi

newVersion="$(node -pe 'require("./package.json").version')"

sed -i -e "s/  VERSION\\s*=\\s*\"$oldVersion\"/  VERSION = \"$newVersion\"/" version.rb
