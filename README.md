# axe-matchers

Automated accessibility testing powered by aXe.

Provides Cucumber step definitions and RSpec matchers for auditing accessibility.

Uses the [aXe core][axe-core] javascript library for accessibility testing.

# Philosophy

We believe that automated testing has an important role to play in achieving digital equality and that in order to do that, it must achieve mainstream adoption by professional web developers. That means that the tests must inspire trust, must be fast, must work everywhere and must be available everywhere.

# Manifesto

1. Automated accessibility testing rules must have a zero false positive rate
2. Automated accessibility testing rules must be lightweight and fast
3. Automated accessibility testing rules must work in all modern browsers
4. Automated accessibility testing rules must, themselves, be tested automatically

# Getting Started

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'axe-matchers'
```

And then execute:

``` sh
$ bundle install
```

Or install it yourself as:

``` sh
$ gem install axe-matchers
```

## Usage

### Cucumber

A set of step definitions have been provided for accessibility testing through Cucumber, using [WebDrivers][webdrivers].

Read the documentation for the [Cucumber Integration][cucumber-integration].

### RSpec

A set of matchers have been provided for accessibility testing through RSpec using [WebDrivers][webdrivers].

Read the documentation for the [RSpec Integration][rspec-integration]

# The Accessibility Rules

The complete list of rules run by axe-core can be found in [doc/rule-descriptions.md][axe-rule-descriptions].

# WebDrivers

axe-matchers supports Capybara, Selenium, and Watir webdrivers; each tested with Firefox, Chrome, and Safari. Additionally, selenium-chrome-headless and capybara-webkit are supported.

*__Notes:__*

- Chrome requires [ChromeDriver][chrome-driver] (tested with 2.35)
- Safari requires [SafariDriver][safari-driver] (tested with 2.48)


# Contributing

Read the documentation on [contributing][contributing]

[webdrivers]: #webdrivers
[cucumber-integration]: ./docs/Cucumber.md
[rspec-integration]: ./docs/RSpec.md
[contributing]: ./CONTRIBUTING.md

[axe-core]: https://github.com/dequelabs/axe-core
[axe-rule-descriptions]: https://github.com/dequelabs/axe-core/blob/master/doc/rule-descriptions.md

[chrome-driver]: https://sites.google.com/a/chromium.org/chromedriver/
[safari-driver]: https://code.google.com/p/selenium/wiki/SafariDriver
