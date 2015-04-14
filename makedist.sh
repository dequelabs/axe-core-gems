#!/usr/bin/env bash

rm -r dist
mkdir dist
cp -r features dist
cp README.md dist
cp dist-Gemfile dist/Gemfile
gem build rspec-a11y.gemspec
cp *.gem dist
