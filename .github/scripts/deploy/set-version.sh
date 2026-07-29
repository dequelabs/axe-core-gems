#!/bin/bash

set -euo pipefail

suffix="${1:-}"
version="$(jq -r .version package.json)"

if [ -n "$suffix" ]; then
  version="$version.$suffix"
fi

cat >version.rb <<RUBY
# this version is used by all the packages

module AxeCoreGems
  VERSION = "$version"
end
RUBY

echo "Publishing version $version"
