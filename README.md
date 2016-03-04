# axe-matchers

Automated accessibility testing powered by aXe.

Provides Cucumber step definitions and RSpec matchers for auditing accessibility.

# Installation

``` sh
gem install axe-matchers
```

or with [bundler](http://bundler.io), add to your `Gemfile`:

``` ruby
gem 'axe-matchers'
```

and run

``` sh
bundle install
```

# Cucumber

## Configuration

1. Require step definitions: in `features/support/env.rb` or similar.

    ``` ruby
    require 'axe/cucumber/step_definitions'
    ```

2. Configure Browser/WebDriver

    If there exists a `page` method on the Cucumber `World` (as is provided by the Capybara DSL), or if one of `@page`, `@browser`, `@driver` or `@webdriver` exist, then no configuration is necessary.  Otherwise, the browser object must be configured manually.

    The browser/page object can be provided directly. Or in cases where it hasn't been instantiated yet, the variable name can be given as a String/Symbol.

    ``` ruby
    @firefox = Selenium::WebDriver.for :firefox

    Axe::Cucumber.configure do |c|
      # browser object
      c.page = @firefox

      # or variable name
      c.page = :@firefox
    end
    ```

## Built-In Accessibility Cucumber Steps

To construct an axe accessibility Cucumber step, begin with the base step, and append any clauses necessary. All of the following clauses may be mixed and matched; however, they must appear in the specified order:

`Then the page should be accessible [including] [excluding] [according-to] [checking-rules/checking-only-rules] [skipping-rules]`

### Base Step

``` gherkin
Then the page should be accessible
```

The base step is the core component of the step. It is a complete step on its own and will verify the currently loaded page is accessible using the default configuration of [axe.a11yCheck][a11ycheck] (the entire document is checked using the default rules).

### Inclusion clause

``` gherkin
Then the page should be accessible within "#selector"
```

The inclusion clause (`within "#selector"`) specifies which elements of the page should be checked. A valid CSS selector must be provided, and is surrounded in double quotes. Compound selectors may be used to select multiple elements. e.g. `within "#header, .footer"`

*see additional [context parameter documentation][context-param]*

### Exclusion clause

``` gherkin
Then the page should be accessible excluding "#selector"
```

The exclusion clause (`excluding "#selector"`) specifies which elements of the document should be ignored. A valid CSS selector must be provided, and is surrounded in double quotes. Compound selectors may be used to select multiple elements. e.g. `excluding "#widget, .ad"`

*see additional [context parameter documentation][context-param]*

If desired, a semicolon (`;`) or the word `but` may be used to separate the exclusion clause from the inclusion clause (if present).

``` gherkin
Then the page should be accessible within "main"; excluding "aside"
Then the page should be accessible within "main" but excluding "aside"
```

### Accessibility Standard (Tag) clause

``` gherkin
Then the page should be accessible according to: tag-name
```

The tag clause specifies which accessibility standard (or standards) should be used to check the page. The accessibility standards are specified by name (tag). Multiple standards can be specified when comma-separated. e.g. `according to: wcag2a, section508`

The acceptable [tag names are documented][options-param] as well as a [complete listing of rules][rules] that correspond to each tag.

If desired, a semicolon (`;`) may be used to separate the tag clause from the preceding clause.

``` gherkin
Then the page should be accessible within "#header"; according to: best-practice
```

### Checking Rules clause

``` gherkin
Then the page should be accessible checking: ruleId
```

The checking-rules clause specifies which *additional* rules to run (in addition to the specified tags, if any, or the default ruleset). The rules are specified by comma-separated rule IDs.

*see [rules documentation][rules] for a list of valid rule IDs*

If desired, a semicolon (`;`) or the word `and` may be used to separate the checking-rules clause from the preceding clause.

``` gherkin
Then the page should be accessible according to: wcag2a; checking: color-contrast
Then the page should be accessible according to: wcag2a and checking: color-contrast
```

#### Exclusive Rules clause

``` gherkin
Then the page should be accessible checking only: ruleId
```

This clause is not really a separate clause. But rather, by adding the word `only` to the checking-rules clause, the meaning of the step can be changed. As described above, by default the checking-rules clause specifies *additional* rules to run. If the word `only` is used, then *only* the specified rules are checked.

### Skipping Rules clause

``` gherkin
Then the page should be accessible skipping: ruleId
```

The skipping-rules clause specifies which rules to skip. This allows an accessibility standard to be provided (via the tag clause) while ignoring a particular rule. The rules are specified by comma-separated rule IDs.

*see [rules documentation][rules] for a list of valid rule IDs*

If desired, a semicolon (`;`) or the word `but` may be used to separate the skipping-rules clause from the preceding clause.

``` gherkin
Then the page should be accessible according to: wcag2a; skipping: accesskeys
Then the page should be accessible according to: wcag2a but skipping: accesskeys
```

## Examples

``` gherkin
Then the page should be accessible within "main, header" but excluding "footer"

Then the page should be accessible excluding "#sidebar" according to: wcag2a, wcag2aa but skipping: color-contrast

Then the page should be accessible checking only: document-title, label

Then the page should be accessible according to: best-practice and checking: aria-roles, definition-list
```

# WebDrivers

axe-matchers supports Capybara, Selenium, and Watir webdrivers; each tested with Firefox, Chrome, Safari, and PhantomJS. Additionally, capybara-webkit and poltergeist are supported.

*__Notes:__*

- Auditing IFrames is not suppored in Poltergeist < 1.8.0. Upgrade to 1.8.0+ or set `skip_iframes=true` in `Axe.configure`
- Chrome requires [ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver/) (tested with 2.21)
- Safari requires [SafariDriver](https://code.google.com/p/selenium/wiki/SafariDriver) (tested with 2.48)



[inclusion-clause]: #inclusion-clause
[exclusion-clause]: #exclusion-clause
[tag-clause]: #accessibility-standard-tag-clause
[rules-clause]: #checking-rules-clause
[exclusive-rules-clause]: #exclusive-rules-clause
[skipping-rules-clause]: #skipping-rules-clause

[a11ycheck]: https://github.com/dequelabs/axe-core/blob/master/doc/API.md#api-name-axea11ycheck
[context-param]: https://github.com/dequelabs/axe-core/blob/master/doc/API.md#a-context-parameter
[options-param]: https://github.com/dequelabs/axe-core/blob/master/doc/API.md#b-options-parameter
[rules]: https://github.com/dequelabs/axe-core/blob/master/doc/rule-descriptions.md
