require 'axe/cucumber/step'

Then Axe::Cucumber::Step::REGEX, :assert_accessibility, on: -> { Axe::Cucumber::Step.create_for self }
