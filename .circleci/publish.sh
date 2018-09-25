#!/bin/bash

set -e

throw() { 
  echo "$@" 1>&2
  exit 1
}

if [ "$CIRCLE_BRANCH" = "develop" ]; then
  rm -rf pkg
  # Add a ".pre.SHA" suffix to the version number.
  sed -i '' "s/spec\.version *= *\"\(.*\)\"/spec.version = \"\1.pre.$(git rev-parse --short HEAD)\"/" axe-matchers.gemspec
  rake build
  gem push --host $(pkg/*.gem)
elif [ "$CIRCLE_BRANCH" = "master" ]; then
  rm -rf pkg
  rake build
  gem push --host $(pkg/*.gem)
else
  throw "Invalid branch. Refusing to publish."
fi