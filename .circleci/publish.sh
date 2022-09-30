#!/bin/bash
set -e

# Setup `gem` credentials
# Based on https://medium.com/@pezholio/publishing-rubygems-using-circle-ci-2-0-1dbf06ae9942.
mkdir -p ~/.gem
echo -e "---\r\n:rubygems_api_key: $RUBYGEMS_API_KEY" >~/.gem/credentials
chmod 0600 ~/.gem/credentials

# Helper fn to update version.rb
setup_version() {
  echo "
  module AxeCoreGems
    VERSION = "\"$1\""
  end
  " >version.rb
}

# get version number
version=$(cat package.json |
  grep version |
  head -1 |
  awk -F: '{ print $2 }' |
  sed 's/[",]//g' |
  tr -d '[[:space:]]')

# version suffix provided?
if [ ! -z "$1" ]; then
  setup_version "$version.$1"
else
  setup_version $version
fi

# publish
rake publish
