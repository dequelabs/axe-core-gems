require 'axe/configuration'

module Axe
  module Support
    WEBDRIVER_NAMES = [ :@page, :@browser, :@driver, :@webdriver ]

    module_function

    def page_from(world)
      configured_page_object ||
        page_by_method_name(world) ||
        page_by_ivar_name(world) ||
        NullWebDriver.new
    end

    private

    def self.configuration
      Axe::Configuration.instance
    end

    def self.configured_page_object
      configuration.page unless configuration.page.is_a?(String) || configuration.page.is_a?(Symbol)
    end

    def self.page_by_method_name(world)
      world.__send__(configuration.page) if world.respond_to?(configuration.page)
    end

    def self.page_by_ivar_name(world)
      if ivar_name = ([configuration.page.to_sym].concat(WEBDRIVER_NAMES) & world.instance_variables).first
        world.instance_variable_get(ivar_name)
      end
    end
  end

  class NullWebDriver; end
end
