require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support

require File.dirname(__FILE__) + "/fixtures/a11y_test_page"

require 'cucumber/a11y'

require 'capybara'
require 'capybara-webkit'
require 'selenium-webdriver'

Capybara.register_driver :selenium_firefox do |app|
  Capybara::Selenium::Driver.new(app, :browser => :firefox)
end

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

module SwitchWebDriver

  def activate_driver(webdriver, browser)
    self.__send__(webdriver, browser)
  end

  private

  def capybara(browser)
    self.extend(Capybara::DSL)

    Capybara.current_driver = browser
  end

  def watir(browser)
    self.extend(Watir::DSL)

    @browser = Watir::Browser.new browser
  end

end

World(SwitchWebDriver)
