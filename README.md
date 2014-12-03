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

## Usage

### RSpec

The simplest use case is to perform an accessibility check for the whole page:

    expect(page).to be_accessible

To perform this check for only a portion of the page:

    expect(page).to be_accessible.within("#id")

TODO

    expect(page).to be_accessible.for_tag("wcag2a")
    expect(page).to be_accessible.for_rule("label")

### Cucumber

The simplest use case is to perform an accessibility check for the whole page:

    Then the page should be accessible

To perform this check for only a portion of the page:

    Then the page should be accessible within "#id"

TODO

    Then the page should be accessible for tag "wcag2a"
    Then the page should be accessible for rule "label"
