require "selenium-webdriver"
require_relative "../../common/axe/configuration"

# Provides a chainable axe API for Selenium WebDriver and automatically injects into all frames

module AxeSelenium
  # todo: allow to specify browser for driver
  def self.configure(*args, &block)
    yield Axe::Configuration.instance if block_given?
  end
end
