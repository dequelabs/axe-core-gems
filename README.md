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

### Cucumber

Require the custom steps in Cucumber's `env` file:

    require 'cucumber/a11y'

## Usage

### RSpec

    expect(page).to be_accessible
    expect(page).to be_accessible_within("#id")

### Cucumber

    Then the page should be accessible
    Then "#id" should be accessible
