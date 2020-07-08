require_relative "./axe-core-cucumber"

Then AxeCucumber::Step::REGEX,
     :assert_accessibility,
     on: -> {
       Axe::Cucumber::Step.create_for self
     }
