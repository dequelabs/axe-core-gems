require 'axe/rspec/matchers'
require 'axe/cucumber/configuration'
require 'axe/cucumber/steps'
require 'axe/cucumber/step_definitions'

# expose rspec matchers to cucumber steps
World(Axe::RSpec::Matchers)

# register module of step procs for step definitions
World(Axe::Cucumber::Steps::Base)
World(Axe::Cucumber::Steps::AccordingToTag)
World(Axe::Cucumber::Steps::CheckingRule)
World(Axe::Cucumber::Steps::WithOptions)
