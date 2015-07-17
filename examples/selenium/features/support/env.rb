# load selenium-webdriver
require 'selenium-webdriver'

# Requiring 'axe/cucumber' makes all of the rspec-axe cucumber step
# definitions available to be used directly in your cucumber features.
require 'axe/cucumber'


# give rspec-axe a handle on the browser/page instance
Axe::Cucumber.configure do |c|
  c.page = :@page

  # rspec-axe can also be given the actual browser/page instance if it's available
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
# rspec-axe is known to work with selenium-webdriver using:
# chrome, firefox, internet explorer, phantomjs, safari
