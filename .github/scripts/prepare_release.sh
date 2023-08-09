#!/bin/bash

# Fail on first error.
set -e

releaseLevel="$1"

npx standard-version --release-as "$releaseLevel" --skip.commit=true --skip.tag=true
