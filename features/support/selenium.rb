require_relative 'env'
require 'selenium-webdriver'

# module so that our test steps can be driver-agnostic
World(Module.new do
  def visit(url)
    @browser.navigate.to url
  end

  def quit
    @browser.quit
  end
end)

Before do
  @browser = Selenium::WebDriver.for $browser
end
