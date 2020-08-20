#!/bin/bash

set -e

echo export BUNDLER_VERSION=2.1 >>$BASH_ENV
source $BASH_ENV
sudo gem install bundler
sudo gem update --system 