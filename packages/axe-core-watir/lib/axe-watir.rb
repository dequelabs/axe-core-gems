require "watir"
require_relative "../../../common/axe/configuration"

module AxeWatir

  # configure method
  # - which takes an optional argument browser
  # - and a configuration block optional for Axe
  def self.configure(browser = :firefox)

    # instantiate axe configuration (singleton) with defaults or given config
    if !block_given?
      raise Exception.new "Please provide a configure block for AxeWatir"
    end

    config = Axe::Configuration.instance

    # provide a watir webdriver page object
    config.page = get_driver(browser)

    # await and return
    yield config
    config
  end

  private

  def self.get_driver(browserSymbol)
    Watir::Browser.new browserSymbol
  end
end
