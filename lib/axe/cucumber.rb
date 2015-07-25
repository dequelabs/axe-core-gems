require 'axe/rspec/matchers'
require 'axe/cucumber/configuration'
require 'axe/cucumber/step'
require 'axe/cucumber/steps'

# expose rspec matchers to cucumber steps
World(Axe::RSpec::Matchers)

# register module of step procs for step definitions
World(Axe::Cucumber::Steps)
