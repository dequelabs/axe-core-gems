# axe-matchers

Automated accessibility testing powered by aXe.

Provides Cucumber step definitions and RSpec matchers for auditing accessibility.

# Installation

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

# Cucumber

## Configuration

1. Require step definitions: in `features/support/env.rb` or similar.

    ``` ruby
    require 'axe/cucumber/step_definitions'
    ```

2. Configure Browser/WebDriver

    If there exists a `page` method on the Cucumber `World` (as is provided by the Capybara DSL), or if one of `@page`, `@browser`, `@driver` or `@webdriver` exist, then no configuration is necessary.  Otherwise, the browser object must be configured manually.

    The browser/page object can be provided directly. Alternatively, when you don't have access to the instantiated driver, the variable or method name can be given as a String/Symbol.

    ``` ruby
    @firefox = Selenium::WebDriver.for :firefox

    Axe::Cucumber.configure do |c|
      # browser object
      c.page = @firefox

      # or variable name
      c.page = :@firefox

      # or method name
      c.page = :firefox
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

The inclusion clause (`within "#selector"`) specifies which elements of the page should be checked. A valid [CSS selector][css selector] must be provided, and is surrounded in double quotes. Compound selectors may be used to select multiple elements. e.g. `within "#header, .footer"`

*see additional [context parameter documentation][context-param]*

### Exclusion clause

``` gherkin
Then the page should be accessible excluding "#selector"
```

The exclusion clause (`excluding "#selector"`) specifies which elements of the document should be ignored. A valid [CSS selector][css selector] must be provided, and is surrounded in double quotes. Compound selectors may be used to select multiple elements. e.g. `excluding "#widget, .ad"`

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

### Exclusive Rules clause

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

# RSpec

`axe/rspec` provides a custom RSpec matcher—`BeAccessible`—which is easily instantiated using the `be_accessible` helper method.

## Configuration

Require rspec matchers: in `spec/spec_helper.rb`.

``` ruby
require 'axe/rspec'
```

## Matchers

### BeAccessible

To construct an axe accessibility RSpec check, begin with `expect(page).to be_accessible`, and append any clauses necessary.

#### Inclusion clause

``` ruby
# Simple selector
expect(page).to be_accessible.within '#selector1'

# Compound selector
# Include all elements with the class 'selector2' inside the element with id 'selector1'
expect(page).to be_accessible.within '#selector1 .selector2'

# Multiple selectors
# Include the element with id 'selector1' *and* all elements with class 'selector2'
expect(page).to be_accessible.within '#selector1', '.selector2'

# IFrame selector
# Include the element with id 'selector1' inside the IFrame with id 'frame1'
expect(page).to be_accessible.within iframe: '#frame1', selector: '#selector1'

# Multiple IFrame selectors
# Include the element with id 'selector1' inside the IFrame with id 'frame1'
# Include the element with id 'selector2' inside the IFrame with id 'frame2'
expect(page).to be_accessible.within(
	{iframe: '#frame1', selector: '#selector1'},
	{iframe: '#frame2', selector: '#selector2'}
)

# Simple selectors *and* IFrame selector
# Include the element with id 'selector1' *and* all elements with class 'selector2'
# Include the element with id 'selector3' inside the IFrame with id 'frame'
expect(page).to be_accessible.within '#selector1', '.selector2', iframe: '#frame', selector: '#selector3'

# Nested IFrame selectors
# Include the element selector1 inside the IFrame with id 'frame2',
# inside the IFrame with id 'frame1'
expect(page).to be_accessible.within(iframe: '#frame1', selector: 
	{iframe: '#frame2', selector: '#selector1'}
)
```

The inclusion clause `within '#selector'` specifies which elements of the page should be checked. A valid [CSS selector][css selector] must be provided. Within accepts a single selector, an array of selectors, or a hash describing iframes with selectors.

*see additional [context parameter documentation][context-param]*

#### Exclusion clause

``` ruby
# Simple selector
expect(page).to be_accessible.excluding '#selector1'

# Compound selector
# Exclude all elements with the class 'selector2' inside the element with id 'selector1'
expect(page).to be_accessible.excluding '#selector1 .selector2'

# Multiple selectors
# Exclude the element with id 'selector1' *and* all elements with class 'selector2'
expect(page).to be_accessible.excluding '#selector1', '.selector2'

# IFrame selector
# Exclude the element with id 'selector1' inside the IFrame with id 'frame1'
expect(page).to be_accessible.excluding iframe: '#frame1', selector: '#selector1'

# Multiple IFrame selectors
# Exclude the element with id 'selector1' inside the IFrame with id 'frame1'
# Exclude the element with id 'selector2' inside the IFrame with id 'frame2'
expect(page).to be_accessible.excluding(
	{iframe: '#frame1', selector: '#selector1'},
	{iframe: '#frame2', selector: '#selector2'}
)

# Simple selectors with IFrame selector
# Exclude the element with id 'selector1' *and* all elements with class 'selector2'
# Exclude the element with id 'selector3' inside the IFrame with id 'frame'
expect(page).to be_accessible.excluding '#selector1', '.selector2', iframe: '#frame', selector: '#selector3'

# Nested IFrame selectors
# Exclude the element selector1 inside the IFrame with id 'frame2',
# inside the IFrame with id 'frame1'
expect(page).to be_accessible.excluding(iframe: '#frame1', selector: 
	{iframe: '#frame2', selector: '#selector1'}
)
```

The exclusion clause `excluding '#selector'` specifies which elements of the document should be ignored. A valid [CSS selector][css selector] must be provided. Excluding accepts a single selector, an array of selectors, or a hash describing iframes with selectors.

*see additional [context parameter documentation][context-param]*

#### Accessibility Standard (Tag) clause

```ruby
# Single standard
expect(page).to be_accessible.according_to :wcag2a

# Multiple standards
expect(page).to be_accessible.according_to :wcag2a, :section508
```

The tag clause specifies which accessibility standard (or standards) should be used to check the page. The accessibility standards are specified by name (tag). According to accepts a single tag, or an array of tags.

The acceptable [tag names are documented][options-param] as well as a [complete listing of rules][rules] that correspond to each tag.


#### Checking Rules clause

``` ruby
# Checking a single rule
expect(page).to be_accessible.checking :label

# Checking multiple rules
expect(page).to be_accessible.checking :label, :tabindex
```

The checking-rules clause specifies which *additional* rules to check (in addition to the specified tags, if any, or the default ruleset). Checking accepts a single rule, or an array of rules.

*see [rules documentation][rules] for a list of valid rule IDs*

``` ruby
# Example specifying an additional best practice rule in addition to all rules in the WCAG2A standard
expect(page).to be_accessible.according_to(:wcag2a).checking(:tabindex)
```

#### Exclusive Rules clause

``` ruby
# Checking a single rule
expect(page).to be_accessible.checking_only :label

# Checking multiple rules
expect(page).to be_accessible.checking_only :label, :tabindex
```

The checking only rules clause specifies which rules to exclusively check. Using this matcher excludes *all* rules outside of the list.

#### Skipping Rules clause

``` ruby
# Skipping a single rule
expect(page).to be_accessible.skipping :label

# Skipping multiple rules
expect(page).to be_accessible.skipping :label, :tabindex
```

The skipping-rules clause specifies which rules to skip. This allows an accessibility standard to be provided (via the tag clause) while ignoring a particular rule. The rules are specified by comma-separated rule IDs.

*see [rules documentation][rules] for a list of valid rule IDs*

``` ruby
# Example specifying an additional best practice rule in addition to all rules in the WCAG2A standard
expect(page).to be_accessible.according_to(:wcag2a).skipping(:label)
```

### Examples

All of the described clauses may be mixed and matched with method chaining.

``` ruby
expect(page).to be_accessible.within('.main', '.header').excluding('.footer')

expect(page).to be_accessible.excluding('#sidebar').according_to(:wcag2a, :wcag2aa).skipping(:color-contrast)

expect(page).to be_accessible.within('.main').checking_only :document-title, :label

expect(page).to be_accessible.according_to(:best-practice).checking(:aria-roles, :definition-list)
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

[css selector]: https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Getting_started/Selectors
