require 'axe/configuration'

module Axe
  class FindsPage
    WEBDRIVER_NAMES = [ :page, :browser, :driver, :webdriver ]

    class << self
      alias :in :new
    end

    def initialize(world)
      @world = world
    end

    def page
      from_configuration || implicit || NullWebDriver.new
    end

    private

    def configuration
      Axe::Configuration.instance
    end

    def from_configuration
      if configuration.page.is_a?(String) || configuration.page.is_a?(Symbol)
        via_method(configuration.page) || via_ivar(configuration.page)
      else
        configuration.page
      end
    end

    def implicit
      WEBDRIVER_NAMES.find { |name|
        via_method(name) || via_ivar(name)
      }
    end

    def via_method(name)
      if @world.respond_to?(name)
        configuration.page = name # make lookup faster on second call
        @world.__send__(name)
      end
    end

    def via_ivar(name)
      # ensure leading '@'
      name = name.to_s.sub(/^([^@])/, '@\1').to_sym

      if @world.instance_variables.include?(name)
        configuration.page = name # make lookup faster on second call
        @world.instance_variable_get(name)
      end
    end
  end

  class NullWebDriver; end
end
