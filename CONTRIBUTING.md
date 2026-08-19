
# Contributing

## Setup

### Requirements

-  Ruby 3.3.0 or later.
-  Bundler for gem dependencies
-  Rake as task runner
-  RSpec for testing
-  Cucumber for testing
-  Node/npm are necessary for pulling down the [axe-core][] package
- **(optional)** Brewdler for system dependencies (chromedriver, etc)

### Ruby version management

[rbenv](https://github.com/rbenv/rbenv) is recommended but you may also use [rvm](https://rvm.io/), [chruby](https://github.com/postmodern/chruby) or other ruby version manager of your choice.
3.3.0 is the minimum version, declared as `required_ruby_version` in each package's gemspec, and is what CI tests against.

The `.ruby-version` is intentionally ignored from the repo for the same reason that `Gemfile.lock` should not be committed. See http://yehudakatz.com/2010/12/16/clarifying-the-roles-of-the-gemspec-and-gemfile/ for more clarification.

### Node version management

[nvm](https://github.com/nvm-sh/nvm) is the recommended node version manager if you have or need multiple versions of node installed simultaneously.
The node version this project targets is pinned in `.nvmrc`, so `nvm use` from the repository root selects it (`nvm install` first if you do not have it yet).
CI reads the same file.

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
- `rake test_unit` to unit test all packages
- `rake format` to format all packages
- `rake publish` to publish all packages

To scope any of the above rake tasks to an individual package, an argument containing the package name can be passed to the rake task:
- `rake test_unit\[axe-core-selenium\]`

> Note: Refer individual packages and the respective README for further information on the lib, specs and rake tasks.

## Releasing

When releasing a new version of `axe-core-gems`:

1. Ensure a clean working directory
2. Change the version number in `package.json`, & commit. It is the source of truth; `version.rb` is generated from it.
3. Run `rake test_unit` to ensure all tests pass.
4. Run `rake build` to generate all gems.
5. To manually release to rubygems: `rake publish`.

> Note: Releases are managed by the continuous integration run via GitHub Actions. See [configuration](./.github/workflows/deploy.yml)

### Publishing credentials

Gems are pushed using [RubyGems trusted publishing](https://guides.rubygems.org/trusted-publishing/): CI exchanges a GitHub OIDC token for short-lived RubyGems.org credentials, so there is no API key stored anywhere.
Each gem's trusted publisher on RubyGems.org is bound to the workflow filename `deploy.yml` and the `release` environment.
Renaming either one stops all publishing until the six gems' publisher entries are updated to match.

Creating the GitHub release is separate and still needs a `PAT` Actions secret, because a tag-protection rule prevents `GITHUB_TOKEN` from creating `v*` tags.
The same secret is used by `sync-master-develop.yml` and `update-axe-core.yml` to open their pull requests.