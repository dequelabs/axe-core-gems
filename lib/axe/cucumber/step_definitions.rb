require 'axe/cucumber'

Then /^the page should(?<negate> not)? be accessible(?: within "(?<inclusion>.*?)")?(?:(?: but)? excluding "(?<exclusion>.*?)")?$/, :accessible, on: Axe::Cucumber.steps



Then 'the page should be accessible according to: $tag', :accessible_according_to, on: Axe::Cucumber.steps

Then 'the page should not be accessible according to: $tag', :inaccessible_according_to, on: Axe::Cucumber.steps

Then 'the page should be accessible within "$inclusion_selector" according to: $tag', :accessible_within_according_to, on: Axe::Cucumber.steps

Then 'the page should not be accessible within "$inclusion_selector" according to: $tag', :inaccessible_within_according_to, on: Axe::Cucumber.steps

Then 'the page should be accessible excluding "$exclusion_selector" according to: $tag', :accessible_excluding_according_to, on: Axe::Cucumber.steps

Then 'the page should not be accessible excluding "$exclusion_selector" according to: $tag', :inaccessible_excluding_according_to, on: Axe::Cucumber.steps

Then 'the page should be accessible within "$inclusion_selector" but excluding "$exclusion_selector" according to: $tag', :accessible_within_but_excluding_according_to, on: Axe::Cucumber.steps

Then 'the page should not be accessible within "$inclusion_selector" but excluding "$exclusion_selector" according to: $tag', :inaccessible_within_but_excluding_according_to, on: Axe::Cucumber.steps



Then 'the page should be accessible checking: $rule', :accessible_checking, on: Axe::Cucumber.steps

Then 'the page should not be accessible checking: $rule', :inaccessible_checking, on: Axe::Cucumber.steps

Then 'the page should be accessible within "$inclusion_selector" checking: $rule', :accessible_within_checking, on: Axe::Cucumber.steps

Then 'the page should not be accessible within "$inclusion_selector" checking: $rule', :inaccessible_within_checking, on: Axe::Cucumber.steps

Then 'the page should be accessible excluding "$exclusion_selector" checking: $rule', :accessible_excluding_checking, on: Axe::Cucumber.steps

Then 'the page should not be accessible excluding "$exclusion_selector" checking: $rule', :inaccessible_excluding_checking, on: Axe::Cucumber.steps

Then 'the page should be accessible within "$inclusion_selector" but excluding "$exclusion_selector" checking: $rule', :accessible_within_but_excluding_checking, on: Axe::Cucumber.steps

Then 'the page should not be accessible within "$inclusion_selector" but excluding "$exclusion_selector" checking: $rule', :inaccessible_within_but_excluding_checking, on: Axe::Cucumber.steps



Then 'the page should be accessible with options $options', :accessible_custom, on: Axe::Cucumber.steps

Then 'the page should not be accessible with options $options', :inaccessible_custom, on: Axe::Cucumber.steps

Then 'the page should be accessible within "$inclusion_selector" with options $options', :accessible_within_custom, on: Axe::Cucumber.steps

Then 'the page should not be accessible within "$inclusion_selector" with options $options', :inaccessible_within_custom, on: Axe::Cucumber.steps

Then 'the page should be accessible excluding "$exclusion_selector" with options $options', :accessible_excluding_custom, on: Axe::Cucumber.steps

Then 'the page should not be accessible excluding "$exclusion_selector" with options $options', :inaccessible_excluding_custom, on: Axe::Cucumber.steps

Then 'the page should be accessible within "$inclusion_selector" but excluding "$exclusion_selector" with options $options', :accessible_within_but_excluding_custom, on: Axe::Cucumber.steps

Then 'the page should not be accessible within "$inclusion_selector" but excluding "$exclusion_selector" with options $options', :inaccessible_within_but_excluding_custom, on: Axe::Cucumber.steps
