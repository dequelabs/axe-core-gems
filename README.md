# Requirements

1. Ruby 2.0.0 or later. Use rbenv (https://github.com/sstephenson/rbenv) or rvm (https://rvm.io/) or other ruby version manager of your choosing to install different Ruby versions.

2. Bundler is used to manage dependencies

    `gem install bundler` to install bundler
    `bundle install` to install necessary gems

    All subsequent commands must be prefixed with `bundle exec` unless you are using bundler binstubs or rbenv-bundle-exec or similar

# Building the gem

1. `rake build` will build the gem and place it into the `pkg` directory.

# Rake Tasks

Rake is the standard task runner. For a list of configured tasks, run `rake -T`

# RSpec Unit Tests

These confirm the proper behavior of the RSpec matcher module. These are located in the `spec` directory and may be run with `rake spec` or `rspec`.

# Cucumber Features

There is a single feature that does a minimal test of the rspec matchers + cucumber steps + axe js library. It is intended as a smoke test to validate against multiple webdrivers. It is currently configured to run against each of:

- capybara driving webkit (headless)
- capybara driving phantomjs (via poltergeist)
- capybara driving phantomjs (via selenium)
- capybara driving firefox (via selenium)
- capybara driving chrome (via selenium)
- capybara driving safari (via selenium)
- watir driving firefox
- watir driving chrome
- watir driving safari

Most of the dependencies necessary for all of the above combinations are provided via gems (installed via bundler)

However, to run the tests against phantomjs, you will need phantomjs installed. And to run the tests against chrome, you will need chromedriver. These can be installed manually, or through homebrew. However, a `Brewfile` has also been supplied to install these non-gem dependencies easily.

`brew tap homebrew/bundle` to install brewdler then:
`brew bundle` will install phantomjs and chromedriver.

Additionally, to test against Safari, the SafariDriver extension is needed. Install it from http://selenium-release.storage.googleapis.com/2.45/SafariDriver.safariextz while using Safari.
