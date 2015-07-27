# This particular example is using all of Capybara's defaults. Which means
# no driver needs to be instantiated. Capybara defaults to the :rack_test
# driver, but automatically switches to selenium (with Firefix) for any
# feature/scenario tagged with @javascript. Notice that selenium-webdriver
# is in the Gemfile.
require 'capybara/cucumber'

# Requiring 'axe/cucumber/step_definitions' makes all of the axe-matchers cucumber step
# definitions available to be used directly in your cucumber features.
require 'axe/cucumber/step_definitions'


# axe-matchers works with capybara out of the box, using the `page` helper as
# provided by Capybara as a reference to the webdriver. No configuration
# necessary.

# Switching webdrivers/browsers with capybara is simple.
# see capybara's documentation: https://github.com/jnicklas/capybara/#drivers
#
# axe-matchers is known to work with Capybara using the following drivers:
# - capybara-webkit
# - selenium (firefox, chrome, safari, ie, phantomjs)
# - poltergeist
