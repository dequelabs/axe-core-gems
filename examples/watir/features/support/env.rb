# load watir-webdriver
require 'watir-webdriver'

# Requiring 'axe/cucumber' makes all of the rspec-axe cucumber step
# definitions available to be used directly in your cucumber features.
require 'axe/cucumber'


# instantiate new browser instance (defaults to firefox)
@page = Watir::Browser.new


# give rspec-axe a handle on the browser/page instance
Axe::Cucumber.configure do |c|
  c.page = @page

  # if the watir driver instance isn't available yet (perhaps it's
  # instantiated within a step), Axe::Cucumber can be configured via just the
  # name of the future instance variable:
  #
  #   c.page = :@page
end

# see watir-webdriver's documentation: http://watirwebdriver.com/ for
# using other browsers
#
# rspec-axe is known to work with watir-webdriver using the following browsers:
# - chrome
# - firefox
# - internet explorer
# - phantomjs
# - safari
