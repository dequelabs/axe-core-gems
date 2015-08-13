

# Requirements

1. Ruby 2.0.0 or later.
2. Bundler for gem dependencies
3. Brewdler for system dependencies (phantomjs, chromedriver, etc)
4. Rake as task runner
5. RSpec for unit tests
6. Cucumber for end to end tests
7. Node/npm are necessary for pulling down the axe-core package

## Ruby Version management

[rbenv](https://github.com/sstephenson/rbenv) is recommended but you may also use [rvm](https://rvm.io/), [chruby](https://github.com/postmodern/chruby) or other ruby version manager of your choice. 2.0.0-p481 is the official minimum version, as it is the default Ruby bundled with OS X Mavericks, but the gem *ought* to support 1.9 and above.

The `.ruby-version` is intentionally ignored from the repo for the same reason that `Gemfile.lock` should not be committed. See http://yehudakatz.com/2010/12/16/clarifying-the-roles-of-the-gemspec-and-gemfile/ for more clarification.

## Bundler

    `gem install bundler` to install bundler
    `bundle install` to install necessary gems

All subsequent commands (when invoking rake, rspec, cucumber, etc) must be prefixed with `bundle exec` unless you are using bundler binstubs or rbenv-bundle-exec or similar. (Elsewhere in this readme, the `bundle exec` prefix will be omitted.)

## Brewdler

Most of the dependencies necessary for running the various test suite configurations are provided via gems and managed by bundler.

However, to run the tests against phantomjs, you will need phantomjs installed. And to run the tests against chrome, you will need chromedriver. Both of these are system dependencies. These can be installed manually, or through homebrew. To ease installation of these non-gem dependencies, a `Brewfile` is provided.

    `brew tap homebrew/bundle` to install brewdler
    `brew bundle` to install phantomjs and chromedriver

Additionally, to test against Safari, the SafariDriver extension is needed. Install it (using Safari) from http://selenium-release.storage.googleapis.com/2.45/SafariDriver.safariextz.

## Rake Tasks

Rake is the standard task runner. For a list of configured tasks, run `rake -T`. Briefly:

- `rake spec` to run unit tests
- `rake cucumber` to run end to end tests
- `rake build` to build and package the gem
- `rake clean` and `rake clobber` to clean up build assets

# RSpec Unit Tests

These confirm the proper behavior of the matchers. These are located in the `spec` directory and may be run with `rake spec` or `rspec`.

# Cucumber Features

There is a single feature that does a minimal test of the matchers + cucumber steps + axe js library. It is intended as a smoke test to validate against multiple webdrivers. Unless a specific profile is specified, cucumber will run the default profile which drives webkit (headless) with capybara. Alternatiely, you may specify the driver and browser combination:

```
cucumber -p capybara -p poltergeist
cucumber -p capybara -p webkit
cucumber -p capybara -p firefox
cucumber -p selenium -p phantomjs
cucumber -p watir -p chrome
```

First specify the driver (one of: `capybara`, `selenium` or `watir`), and choose the browser (`firefox`, `chrome`, `safari`, `phantomjs`). All three drivers support all four browsers. Capybara alone also supports `webkit` and `poltergeist`.

These profile configurations can also be run via rake: `rake cucumber:{driver}:{browser}`. For example:

```
rake cucumber:capybara:firefox
rake cucumber:selenium:chrome
rake cucumber:watir:phantomjs
```

You may omit the browser (`rake cucumber:capybara`) and it will run the features under every configured browser for the given driver. Alternatively, you may omit the driver (`rake cucumber:firefox`) and it will run the features with each driver for the given browser. Additionally, there are special options to run every driver/browser combination `rake cucumber:all`, or only the headless browsers `rake cucumber:headless`. (Headless combinations are capybara+poltergeist, capybara+webkit, capybara+phantomjs, selenium+phantomjs, watir+phantomjs)