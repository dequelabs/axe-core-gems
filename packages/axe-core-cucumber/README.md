# `axe-core-cucumber`
The `axe-core-cucumber` gem provides a custom step defintions to evalaute the accessibility of a given page.

## Usage

1. Install the required gem:

``` gemspec
gem 'axe-core-cucumber'
```

2. Require the step defintions:

``` rb
require 'axe-core-cucumber-step-definitions'
```

3. Use with webdriver of choice.

## Cucumber Steps

### Base Step

The base step `be axe clean` is the core component of the step. It is a complete step on its own and will verify the currently loaded page is axe clean using the default configuration of [axe.run][axe-run] (the entire document is checked using the default rules).

```gherkin
Then the page should be axe clean
```

#### Clauses

Clauses are chainable methods for the `be axe clean` custom step.Configurable clauses allows for greater granularity with testing and expectaions.

##### `within` - Inclusion clause

The inclusion clause ( `within "#selector"` ) specifies which elements of the page should be checked. A valid [CSS selector][css selector] must be provided, and is surrounded in double quotes. Compound selectors may be used to select multiple elements. e.g. `within "#header, .footer"`
*see additional [context parameter documentation][context-param]*

``` gherkin
Then the page should be axe clean within "#selector"
```

##### `excluding` - Exclusion clause

The exclusion clause ( `excluding "#selector"` ) specifies which elements of the document should be ignored. A valid [CSS selector][css selector] must be provided, and is surrounded in double quotes. Compound selectors may be used to select multiple elements. e.g. `excluding "#widget, .ad"`
*see additional [context parameter documentation][context-param]*

``` gherkin
Then the page should be axe clean excluding "#selector"
```

If desired, a semicolon ( `;` ) or the word `but` may be used to separate the exclusion clause from the inclusion clause (if present).

``` gherkin
Then the page should be axe clean within "main"; excluding "aside"
Then the page should be axe clean within "main" but excluding "aside"
```

##### `according to` - Accessibility Standard (Tag) clause

The tag clause specifies which accessibility standard (or standards) should be used to check the page. The accessibility standards are specified by name (tag). Multiple standards can be specified when comma-separated. e.g. `according to: wcag2a, section508`
The acceptable [tag names are documented][options-param] as well as a [complete listing of rules][rules] that correspond to each tag.

``` gherkin
Then the page should be axe clean according to: tag-name
```

If desired, a semicolon ( `;` ) may be used to separate the tag clause from the preceding clause.

``` gherkin
Then the page should be axe clean within "#header"; according to: best-practice
```

##### `checking` - Checking Rules clause

The checking-rules clause specifies which *additional* rules to run (in addition to the specified tags, if any, or the default ruleset). The rules are specified by comma-separated rule IDs.

``` gherkin
Then the page should be axe clean checking: ruleId
```

*see [rules documentation][rules] for a list of valid rule IDs*

If desired, a semicolon ( `;` ) or the word `and` may be used to separate the checking-rules clause from the preceding clause.

``` gherkin
Then the page should be axe clean according to: wcag2a; checking: color-contrast
Then the page should be axe clean according to: wcag2a and checking: color-contrast
```

##### `checking only` - Exclusive Rules clause

This clause is not really a separate clause. But rather, by adding the word `only` to the checking-rules clause, the meaning of the step can be changed. As described above, by default the checking-rules clause specifies *additional* rules to run. If the word `only` is used, then *only* the specified rules are checked.

``` gherkin
Then the page should be axe clean checking only: ruleId
```

##### `skipping` - Skipping Rules clause

The skipping-rules clause specifies which rules to skip. This allows an accessibility standard to be provided (via the tag clause) while ignoring a particular rule. The rules are specified by comma-separated rule IDs.

``` gherkin
Then the page should be axe clean skipping: ruleId
```

*see [rules documentation][rules] for a list of valid rule IDs*

If desired, a semicolon ( `;` ) or the word `but` may be used to separate the skipping-rules clause from the preceding clause.

``` gherkin
Then the page should be axe clean according to: wcag2a; skipping: accesskeys
Then the page should be axe clean according to: wcag2a but skipping: accesskeys
```

##### Interoperability between clauses

All of the described clauses may be mixed and matched with method chaining. Below are some examples.

``` gherkin
Then the page should be axe clean within "main, header" but excluding "footer"

Then the page should be axe clean excluding "#sidebar" according to: wcag2a, wcag2aa but skipping: color-contrast

Then the page should be axe clean checking only: document-title, label

Then the page should be axe clean according to: best-practice and checking: aria-roles, definition-list
```

[inclusion-clause]: #inclusion-clause
[exclusion-clause]: #exclusion-clause
[tag-clause]: #accessibility-standard-tag-clause
[rules-clause]: #checking-rules-clause
[exclusive-rules-clause]: #exclusive-rules-clause
[skipping-rules-clause]: #skipping-rules-clause

[axe-run]: https://github.com/dequelabs/axe-core/blob/master/doc/API.md#api-name-axerun
[context-param]: https://github.com/dequelabs/axe-core/blob/master/doc/API.md#context-parameter
[options-param]: https://github.com/dequelabs/axe-core/blob/master/doc/API.md#options-parameter
[rules]: https://github.com/dequelabs/axe-core/blob/master/doc/rule-descriptions.md

[css selector]: https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Getting_started/Selectors
