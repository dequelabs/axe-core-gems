require 'axe/cucumber/step'

Then Axe::Cucumber::Step::REGEX, :be_accessible, on: -> { Axe::Cucumber::Step.create_for self }
