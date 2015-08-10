require_relative 'env'
require 'selenium-webdriver'

# module so that our test steps can be driver-agnostic
World(Module.new do
  def visit(url)
    @browser.navigate.to url
  end
end)

Before do
  @browser = Selenium::WebDriver.for $browser
end

After do
  @browser.quit
end
