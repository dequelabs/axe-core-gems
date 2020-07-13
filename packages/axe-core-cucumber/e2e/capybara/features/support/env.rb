require "capybara/cucumber"

# Requiring 'axe/cucumber/step_definitions' makes all of the axe-matchers cucumber step
# definitions available to be used directly in your cucumber features.
require "axe-cucumber-step-definitions"

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :selenium)
end

Capybara.javascript_driver = :selenium

# axe-matchers works with capybara out of the box, using the `page` helper as
# provided by Capybara as a reference to the webdriver. No configuration
# necessary.

# Switching webdrivers/browsers with capybara is simple.
# see capybara's documentation: https://github.com/jnicklas/capybara/#drivers
#
# axe-matchers is known to work with Capybara using the following drivers:
# - capybara-webkit
# - selenium (firefox, chrome, chrome headless, safari, ie)
