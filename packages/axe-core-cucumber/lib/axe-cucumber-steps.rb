require_relative "./axe-cucumber"

Then AxeCucumber::Step::REGEX, :assert_accessibility, on: -> { AxeCucumber::Step.create_for self }
