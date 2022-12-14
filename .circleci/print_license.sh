#!/bin/bash

for dir in packages/*; do
  cd "$dir"

  echo ""
  echo ""
  echo ""
  echo ""
  echo "Printing dependencies for $dir"

  bundle exec ruby > licenses <<RUBY
  licenses = {}
  Gem.loaded_specs.each do |name, spec|
    license = spec.license
    if not licenses.key?(license)
    licenses[license] = []
    end
    licenses[license].push(name)
  end
  licenses.each do |license, names|
    puts license
    names.each do |name|
      puts "\t#{name}"
    end
    puts ""
  end
RUBY
  cat licenses
  # Matches words at the beginning of the line that contain "gpl".
  # We add a tab to package names so this prevents false-positives.
  cat licenses |  grep -i -P '^[^\s]*gpl'
  result=$?
  if [ $result -eq  0 ]; then
    echo "Discovered a dependency using the GPL license"
    exit 1
  fi

  cd -
done
