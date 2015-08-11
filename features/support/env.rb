require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support

# require File.dirname(__FILE__) + "/fixtures/a11y_test_page"

require 'axe/cucumber/step_definitions'


require_relative '../../features/step_definitions/test_steps'

$browser = ENV["BROWSER"].to_sym
