
# Contributing

## Setup

### Requirements

-  Ruby 2.0.0 or later.
-  Bundler for gem dependencies
-  Rake as task runner
-  RSpec for testing
-  Cucumber for testing
-  Node/npm are necessary for pulling down the [axe-core][] package
- **(optional)** Brewdler for system dependencies (chromedriver, etc)

### Ruby version management

[rbenv](https://github.com/rbenv/rbenv) is recommended but you may also use [rvm](https://rvm.io/), [chruby](https://github.com/postmodern/chruby) or other ruby version manager of your choice. 2.0.0-p481 is the official minimum version, as it is the default Ruby bundled with OS X Mavericks, but the gem *ought* to support 1.9 and above.

The `.ruby-version` is intentionally ignored from the repo for the same reason that `Gemfile.lock` should not be committed. See http://yehudakatz.com/2010/12/16/clarifying-the-roles-of-the-gemspec-and-gemfile/ for more clarification.

### Node version management

Similar to rbenv, [nodenv](https://github.com/nodenv/nodenv) is the recommended node version manager if you have or need multiple versions of node installed simultaneously.

### Bundler

```sh
gem install bundler #to install bundler
```

Run `bundle install`  with in each of the packages  to install necessary gem dependencies.

All subsequent commands (when invoking rake, rspec, cucumber, etc) must be prefixed with `bundle exec` unless you are using bundler binstubs or rbenv-bundle-exec or similar. (Elsewhere in this readme, the `bundle exec` prefix will be omitted.)

## Brewdler

Most of the dependencies necessary for running the various test suite configurations are provided via gems and managed by bundler.

To run the tests against chrome, you will need chromedriver as a system dependency. This can be installed manually, or through homebrew. To ease installation of non-gem dependencies, a `Brewfile` is provided.

It is recommended that you visually inspect the Brewfile to ensure there are no conflicts with existing tools already on your system. Each tool can be installed manually as necessary.

    `brew tap homebrew/bundle` to install brewdler
    `brew bundle` to install chromedriver and node

Additionally, to test against Safari, the SafariDriver extension is needed. Install it (using Safari) from http://selenium-release.storage.googleapis.com/2.48/SafariDriver.safariextz.

# Rake Tasks

The repository follows a monorepo structure. A [Rakefile]('./Rakefile) has been setup to easily manage tasks from within each of the packages. For a list of configured tasks, run `rake -T`. 

Briefly:
- `rake bootstrap` to setup all packages
- `rake build` to build all packages
- `rake test` to build all packages
- `rake format` to format all packages
- `rake clobber` to clean up build assets

To scope any of the above rake tasks to an individual package, an argument containing the package name can be passed to the rake task:
- `rake test\[axe-core-selenium\]`

> Note: Refer individual packages and the respective README for further information on the lib, specs and rake tasks.

## Releasing

When releasing a new version of `axe-core-gems`:

1. Ensure a clean working directory
2. Change version number in `version.rb` at the root level, & commit.
3. Run `rake test` to ensure all tests pass.
4. Run `rake build` to generate all gems.
5. To manually release to rubygems: `rake release`.

> Note: Releases are managed by the continuous integration run via Circle CI. See [configuration](./.circleci/config.yml)