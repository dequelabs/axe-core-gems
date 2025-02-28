require "selenium-webdriver"
require "axe/configuration"

module AxeSelenium
  # configure method
  # - which takes an optional argument browser
  # - an optional options (sic) object to configure the underlying driver
  # - and a configuration block optional for Axe
  def self.configure(browser = :firefox, opts = {})
    # instantiate axe configuration (singleton) with defaults or given config
    if !block_given?
      raise Exception.new "Please provide a configure block for AxeSelenium"
    end

    config = Axe::Configuration.instance

    # provide a selenium webdriver page object
    config.page = get_driver(browser, opts)

    # await and return
    yield config
    config
  end

  private

  def self.get_driver(*args)
    Selenium::WebDriver.for *args
  end
end
