require 'axe/cucumber'

Then /^the page should(?<negate> not)? be accessible(?: within "(?<inclusion>.*?)")?(?:(?: but)? excluding "(?<exclusion>.*?)")?(?: according to: (?<tags>.*?))?(?: checking(?<run_only> only)?: (?<run_rules>.*?))?(?: skipping: (?<skip_rules>.*?))?(?: with options: (?<options>.*?))?$/, :accessible, on: Axe::Cucumber.steps
