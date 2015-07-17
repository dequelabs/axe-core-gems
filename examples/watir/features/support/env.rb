# load watir-webdriver
require 'watir-webdriver'

# Requiring 'axe/cucumber' makes all of the rspec-axe cucumber step
# definitions available to be used directly in your cucumber features.
require 'axe/cucumber'


# give rspec-axe a handle on the browser/page instance
Axe::Cucumber.configure do |c|
  c.page = :@page

  # rspec-axe can also be given the actual browser/page instance if it's available
  #   c.page = @page
end

# instantiate new browser instance (defaults to firefox) before scenarios
Before do
  @page = Watir::Browser.new
end

# close browser when done
After do
  @page.close
end


# for using other browsers, see watir-webdriver's documentation:
# http://watirwebdriver.com/
#
# rspec-axe is known to work with watir-webdriver using:
# chrome, firefox, internet explorer, phantomjs, safari
