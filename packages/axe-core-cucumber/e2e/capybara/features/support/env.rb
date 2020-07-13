require "capybara/cucumber"
# require driver of choice
require "axe-capybara"
# Requiring 'axe/cucumber/step_definitions' makes all of the axe-cucumber step
# definitions available to be used directly in your cucumber features.
require "axe-cucumber-step-definitions"
# configure `AxeCapybara`
@page = AxeCapybara.configure("firefox") do |c|
end
