#!/bin/bash

set -euo pipefail

suffix="${1:-}"
version="$("$(dirname "$0")/read-version.sh")"

if [ -n "$suffix" ]; then
  # The suffix is interpolated into a Ruby string literal below, so it is
  # restricted to dot-separated alphanumerics.
  if [[ ! "$suffix" =~ ^[0-9A-Za-z]+(\.[0-9A-Za-z]+)*$ ]]; then
    echo "version suffix is not dot-separated alphanumerics: $suffix" >&2
    exit 1
  fi
  version="$version.$suffix"
fi

cat >version.rb <<RUBY
# this version is used by all the packages

module AxeCoreGems
  VERSION = "$version"
end
RUBY

echo "Publishing version $version"
