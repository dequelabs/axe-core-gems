require "selenium-webdriver"
require_relative "../../../common/axe/configuration"

module AxeSelenium

  # configure method
  # - which takes an optional argument browser
  # - and a configuration block optional for Axe
  def self.configure(browser = :firefox)

    # instantiate axe configuration (singleton) with defaults or given config
    if !block_given?
      raise Exception.new "Please provide a configure block for AxeSelenium"
    end

    config = Axe::Configuration.instance

    # provide a selenium webdriver page object
    config.page = get_driver(browser)

    # await and return
    yield config
    config
  end

  private

  # todo: allow to pass driver options (this option does not exist today - create a feature issue)
  def self.get_driver(browserSymbol)
    Selenium::WebDriver.for browserSymbol
  end
end
