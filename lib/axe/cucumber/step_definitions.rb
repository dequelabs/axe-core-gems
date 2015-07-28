require 'axe/cucumber'

Then /^the page should(?<negate> not)? be accessible(?: within "(?<inclusion>.*?)")?(?:(?: but)? excluding "(?<exclusion>.*?)")?(?: according to: (?<tags>.*?))?(?: checking(?<run_only> only)?: (?<run_rules>.*?))?$/, :accessible, on: Axe::Cucumber.steps

Then 'the page should be accessible with options $options', :accessible_custom, on: Axe::Cucumber.steps

Then 'the page should not be accessible with options $options', :inaccessible_custom, on: Axe::Cucumber.steps

Then 'the page should be accessible within "$inclusion_selector" with options $options', :accessible_within_custom, on: Axe::Cucumber.steps

Then 'the page should not be accessible within "$inclusion_selector" with options $options', :inaccessible_within_custom, on: Axe::Cucumber.steps

Then 'the page should be accessible excluding "$exclusion_selector" with options $options', :accessible_excluding_custom, on: Axe::Cucumber.steps

Then 'the page should not be accessible excluding "$exclusion_selector" with options $options', :inaccessible_excluding_custom, on: Axe::Cucumber.steps

Then 'the page should be accessible within "$inclusion_selector" but excluding "$exclusion_selector" with options $options', :accessible_within_but_excluding_custom, on: Axe::Cucumber.steps

Then 'the page should not be accessible within "$inclusion_selector" but excluding "$exclusion_selector" with options $options', :inaccessible_within_but_excluding_custom, on: Axe::Cucumber.steps
