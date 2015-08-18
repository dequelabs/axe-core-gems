# load selenium-webdriver
require 'selenium-webdriver'

# Requiring 'axe/cucumber/step_definitions' makes all of the axe-matchers cucumber step
# definitions available to be used directly in your cucumber features.
require 'axe/cucumber/step_definitions'


# give axe-matchers a handle on the browser/page instance
Axe.configure do |c|
  c.page = :@page

  # axe-matchers can also be given the actual browser/page instance if it's available
  #   c.page = @page
end

# instantiate new browser instance before scenarios
Before do
  @page = Selenium::WebDriver.for :firefox
end

# close browser when done
After do
  @page.quit
end


# for using other browsers, see selenium-webdriver's documentation:
# https://github.com/SeleniumHQ/selenium/tree/master/rb
#
# axe-matchers is known to work with selenium-webdriver using:
# chrome, firefox, internet explorer, phantomjs, safari
