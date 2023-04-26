require "capybara"
require "selenium-webdriver"
require "axe/configuration"

module AxeCapybara
  # configure method
  # - which takes an optional argument browser
  # - and a configuration block optional for Axe
  def self.configure(browser = :firefox)
    # instantiate axe configuration (singleton) with defaults or given config
    if !block_given?
      raise Exception.new "Please provide a configure block for AxeCapybara"
    end

    config = Axe::Configuration.instance

    set_driver(browser)

    # await and return
    yield config
    config
  end

  private

  def self.set_driver(browserSymbol)
    if browserSymbol == :chrome
      Capybara.default_driver = :selenium_chrome
      Capybara.javascript_driver = :selenium_chrome
    else
      Capybara.default_driver = :selenium
      Capybara.javascript_driver = :selenium
    end
  end
end
