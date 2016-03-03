
- [Setup](#setup)
- [Rake Tasks](#rake-tasks)
- [Build and Release](#build-and-release)
- [Tests](#tests)

# Setup

## Requirements

1. Ruby 2.0.0 or later.
2. Bundler for gem dependencies
3. (optional) Brewdler for system dependencies (phantomjs, chromedriver, etc)
4. Rake as task runner
5. RSpec for unit and integration tests
6. Cucumber for smoke tests
7. Node/npm are necessary for pulling down the axe-core package

## Ruby version management

[rbenv](https://github.com/rbenv/rbenv) is recommended but you may also use [rvm](https://rvm.io/), [chruby](https://github.com/postmodern/chruby) or other ruby version manager of your choice. 2.0.0-p481 is the official minimum version, as it is the default Ruby bundled with OS X Mavericks, but the gem *ought* to support 1.9 and above.

The `.ruby-version` is intentionally ignored from the repo for the same reason that `Gemfile.lock` should not be committed. See http://yehudakatz.com/2010/12/16/clarifying-the-roles-of-the-gemspec-and-gemfile/ for more clarification.

## Node version management

Similar to rbenv, [nodenv](https://github.com/nodenv/nodenv) is the recommended node version manager if you have or need multiple versions of node installed simultaneously.

## Bundler

    `gem install bundler` to install bundler
    `bundle install` to install necessary gem dependencies

All subsequent commands (when invoking rake, rspec, cucumber, etc) must be prefixed with `bundle exec` unless you are using bundler binstubs or rbenv-bundle-exec or similar. (Elsewhere in this readme, the `bundle exec` prefix will be omitted.)

## Brewdler

Most of the dependencies necessary for running the various test suite configurations are provided via gems and managed by bundler.

However, to run the tests against phantomjs, you will need phantomjs installed. And to run the tests against chrome, you will need chromedriver. Both of these are system dependencies. These can be installed manually, or through homebrew. To ease installation of these non-gem dependencies, a `Brewfile` is provided.

It is recommended that you visually inspect the Brewfile to ensure there are no conflicts with existing tools already on your system. Each tool can be installed manually as necessary, and are even optional. (phantomjs and chromedriver are only necessary if running the cucumber smoke tests against phantomjs and chrome, respectively)

    `brew tap homebrew/bundle` to install brewdler
    `brew bundle` to install phantomjs, chromedriver, and node

Additionally, to test against Safari, the SafariDriver extension is needed. Install it (using Safari) from http://selenium-release.storage.googleapis.com/2.48/SafariDriver.safariextz.

# Rake Tasks

Rake is the standard task runner. For a list of configured tasks, run `rake -T`. Briefly:

- `rake spec` to run unit tests
- `rake cucumber` to run end to end tests
- `rake build` to build and package the gem
- `rake clobber` to clean up build assets

# Build and Release

 - `rake build`: build gem into the pkg directory
 - `rake install`: build and install into system gems
 - `rake clobber`: remove generated files (pkg/, node_modules/)

## Updating axe-core js lib

 - `rake npm:install`: install axe-core (and any other npm dependencies)
 - `rake npm:update`: update axe-core (and any other npm dependencies) to latest version allowed by package.json
 - `rake npm:upgrade`: upgrade axe-core dependency to latest version available, overwriting (and saving to) package.json

## Releasing

When releasing a new build of axe-matchers to bump axe-core:

1. Ensure a clean working directory
2. Run `rake npm:update` or `rake npm:upgrade` as relevant and commit any package.json changes
3. Bump and commit axe-matchers version in `lib/axe/version.rb`
4. Run tests
5. Release to rubygems: `rake release`

# Tests

## RSpec Tests (unit and integration)

These confirm the proper behavior of the matchers. These are located in the `spec` directory and may be run with `rake spec` or `rspec`.

In addition to the full spec task,  there is `rake spec:ci`, which runs the full suite and generates xUnit output suitable for many CI runners.

Additionally, a couple notable specs are tagged with `:slow`. To skip them and run just the fast suite, there is `rake spec:fast`

see also: `rake -T spec`


## Cucumber Features (smoke tests)

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

see `rake -T cucumber`

You may omit the browser (`rake cucumber:capybara`) and it will run the features under every configured browser for the given driver. Alternatively, you may omit the driver (`rake cucumber:firefox`) and it will run the features with each driver for the given browser. Additionally, there are special options to run every driver/browser combination `rake cucumber:all`, or only the headless browsers `rake cucumber:headless`. (Headless combinations are capybara+poltergeist, capybara+webkit, capybara+phantomjs, selenium+phantomjs, watir+phantomjs)

The profiles are configured in `config/cucumber.yml`. Each profile explicitly requires the appropriate env file based on the driver. This overrides Cucumber's default behavior of automatically requiring the entire `features/support/*.rb` tree. Each of the driver-specific env files in turn requires the common `features/support/env.rb` file. The driver-specific files are intended to import, configure, and wrap each of the drivers such that the step definitions can interact with any of the drivers via the same commands.
