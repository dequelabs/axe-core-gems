# RSpec

`axe/rspec` provides a custom RSpec matcher—`BeAccessible`—which is easily instantiated using the `be_accessible` helper method.

## Configuration

Require rspec matchers:

``` ruby
# in spec/spec_helper.rb
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

[context-param]: https://github.com/dequelabs/axe-core/blob/master/doc/API.md#context-parameter
[options-param]: https://github.com/dequelabs/axe-core/blob/master/doc/API.md#options-parameter
[rules]: https://github.com/dequelabs/axe-core/blob/master/doc/rule-descriptions.md

[css selector]: https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Getting_started/Selectors
