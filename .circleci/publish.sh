#!/bin/bash

set -e

# Setup `gem` credentials.
# Based on https://medium.com/@pezholio/publishing-rubygems-using-circle-ci-2-0-1dbf06ae9942.
mkdir ~/.gem
echo -e "---\r\n:rubygems_api_key: $RUBYGEMS_API_KEY" > ~/.gem/credentials
chmod 0600 ~/.gem/credentials

if [ "$CIRCLE_BRANCH" = "develop" ]; then
  rm -rf pkg
  # Add a ".pre.SHA" suffix to the version number.
  sed -i -e "s/spec\.version\s*=\s'\(.*\)'/spec.version='\1.pre.$(git rev-parse --short HEAD)'/" axe-matchers.gemspec 
  rake build
  gem push $(pkg/*.gem)
elif [ "$CIRCLE_BRANCH" = "master" ]; then
  rm -rf pkg
  rake build
  gem push $(pkg/*.gem)
else
  echo "Invalid branch. Refusing to publish." 1>&2
  exit 1
fi