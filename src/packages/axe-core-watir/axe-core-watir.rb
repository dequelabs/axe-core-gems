require "watir"
require_relative "../../common/axe/configuration"

module AxeWatir

  # configure method
  # - which takes an optional argument browser
  # - and a configuration block optional for Axe
  def self.configure(browser = "firefox")

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

  # todo: allow to pass driver options (this option does not exist today - create a feature issue)
  def self.get_driver(browserName)
    case browserName
    when "chrome"
      Watir::Browser.new :chrome
    when "safari"
      Watir::Browser.new :safari
    when "internet_explorer"
      Watir::Browser.new :internet_explorer
    when "edge"
      Watir::Browser.new :edge
    when "firefox"
      Watir::Browser.new :firefox
    else
      Watir::Browser.new :firefox
    end
  end
end
