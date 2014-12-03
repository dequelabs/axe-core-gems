# Rspec::A11y

Defines custom RSpec matchers and Cucumber steps for testing page accessibility with Deque's WorldSpace Web API.

## Prerequisites

Make sure that the `kensington.min.js` file has been downloaded from Deque and is being loaded on the page within the test environment.

## Installation

Add this line to your application's `Gemfile`:

    gem 'rspec-a11y'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-a11y

### Rspec

Require the custom matchers in Rspec's `spec_helper` file:

    require 'rspec/a11y'

Then include the custom matchers in the spec files where you need them with

    include CustomA11yMatchers

or include the custom matchers globally in a `spec_helper` file with

    RSpec::configure do |config|
      config.include(CustomA11yMatchers)
    end

### Cucumber

Require the custom step definitions in Cucumber's `env` file:

    require 'cucumber/a11y'

## RSpec Usage

The simplest use case is to perform an accessibility check for the whole page:

    expect(page).to be_accessible

#### Limiting the context of the test

To check only a portion of the page, pass a CSS selector to `within()`:

    expect(page).to be_accessible.within("#testme")

To exclude a portion of the page from the check, pass a CSS selector or selectors to `excluding()`:

    expect(page).to be_accessible.excluding(".excludeme")
    expect(page).to be_accessible.excluding(".exclude1,.exclude2")
    expect(page).to be_accessible.excluding([".exclude1",".exclude2"])


The `within()` and `excluding()` methods can be used together:

    expect(page).to be_accessible.within("#testme").excluding(".excludeme")

#### Passing custom options

To perform checks that are more complex than what's provided, pass a string containing your javascript options to `with_options()`:

    expect(page).to be_accessible.with_options('{rules:{"ruleId1":{enabled:false},"ruleId2":{enabled: false}}}')

## Cucumber Usage

The simplest use case is to perform an accessibility check for the whole page:

    Then the page should be accessible

#### Limiting the context of the test

To check only a portion of the page:

    Then the page should be accessible within "#testme"

To exclude a portion or portions of the page from the check:

    Then the page should be accessible excluding ".excludeme"
    Then the page should be accessible excluding ".exclude1,.exclude2"

These limiters can be used together:

    Then the page should be accessible within "#testme" excluding ".excludeme"

#### Passing custom options

To perform checks that are more complex than what's built in to the matchers:

    Then the page should be accessible with options "{rules:{'ruleId1':{enabled:false},'ruleId2':{enabled: false}}}"
