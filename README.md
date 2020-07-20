# axe-core-gems

This repository contains 6 pacakges/ gems, which can be used for automated accesibility testing powered by [axe core][axe-core].

The gems are as below:
- [`axe-core-api`](./packages/axe-core-api/README.md)
- [`axe-core-capybara`](./packages/axe-core-capybara/README.md)
- [`axe-core-cucumber`](./packages/axe-core-cucumber/README.md)
- [`axe-core-rspec`](./packages/axe-core-rspec/README.md)
- [`axe-core-selenium`](./packages/axe-core-selenium/README.md)
- [`axe-core-watir`](./packages/axe-core-watir/README.md)

## Getting Started

Using `axe-core-gems` is a 2 step process.
- Choosing and configuring a webdriver (Capybara, Watir or Selenium)
- Choose a testing framework (RSpec or Cucumber)

Then, add the respective gems to your application:

Eg: 
``` ruby
gem install axe-core-selenium
gem install axe-core-rspec
```

Please refer to respective README for installation, usage & configuration notes.

## Philosophy

We believe that automated testing has an important role to play in achieving digital equality and that in order to do that, it must achieve mainstream adoption by professional web developers. That means that the tests must inspire trust, must be fast, must work everywhere and must be available everywhere.

## Manifesto

1. Automated accessibility testing rules must have a zero false positive rate
2. Automated accessibility testing rules must be lightweight and fast
3. Automated accessibility testing rules must work in all modern browsers
4. Automated accessibility testing rules must, themselves, be tested automatically

## Contributing

Read the documentation on [contributing][contributing]

[contributing]: ./CONTRIBUTING.md
[axe-core]: https://github.com/dequelabs/axe-core
