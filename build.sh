#!/usr/bin/env bash

rm -r dist
rm *.gem
mkdir dist
gem build rspec-a11y.gemspec
cp *.gem dist
