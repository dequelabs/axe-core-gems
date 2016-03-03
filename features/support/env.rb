require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support

# require File.dirname(__FILE__) + "/fixtures/a11y_test_page"

# to use out of the box step definitions
require 'axe/cucumber/step_definitions'

# to use rspec axe-matchers for custom steps
require 'axe/matchers'
World Axe::Matchers

# step defs for our test suite
require_relative '../../features/step_definitions/steps'

# env var set via config/cucumber.yml profile
$browser = ENV["BROWSER"].to_sym
