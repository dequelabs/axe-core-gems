require_relative "./axe-core-cucumber"

Then AxeCucumber::Step::REGEX, :assert_accessibility, on: -> { AxeCucumber::Step.create_for self }
