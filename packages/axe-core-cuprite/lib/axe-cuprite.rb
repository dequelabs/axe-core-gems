require "capybara/cuprite"
require "axe/configuration"

module AxeCuprite
  # - options: an optional hash passed to Capybara::Cuprite::Driver
  # - requires a configuration block for Axe
  def self.configure(options = {})
    raise ArgumentError, "Please provide a configure block for AxeCuprite" unless block_given?

    config = Axe::Configuration.instance
    config.page = get_driver(options)
    yield config
    config
  end

  def self.get_driver(options)
    Capybara::Cuprite::Driver.new(nil, options)
  end
  private_class_method :get_driver
end
