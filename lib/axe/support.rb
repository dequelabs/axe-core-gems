require 'axe/configuration'

module Axe
  module Support
    WEBDRIVER_NAMES = [ :page, :browser, :driver, :webdriver ]

    module_function

    def page_from(world)
      configured_page_object(world) ||
        implicit_page_from(world) ||
        NullWebDriver.new
    end

    private

    def self.configuration
      Axe::Configuration.instance
    end

    def self.configured_page_object(world)
      if configuration.page.is_a?(String) || configuration.page.is_a?(Symbol)
        page_via_method(world, configuration.page) || page_via_ivar(world, configuration.page)
      else
        configuration.page
      end
    end

    def self.implicit_page_from(world)
      WEBDRIVER_NAMES.find { |name|
        page_via_method(world, name) || page_via_ivar(world, name)
      }
    end

    def self.page_via_method(world, name)
      if world.respond_to?(name)
        world.__send__(configuration.page = name)
      end
    end

    def self.page_via_ivar(world, name)
      # ensure leading '@'
      name = name.to_s.sub(/^([^@])/, '@\1').to_sym

      if world.instance_variables.include?(name)
        world.instance_variable_get(configuration.page = name)
      end
    end
  end

  class NullWebDriver; end
end
