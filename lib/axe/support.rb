require 'axe'

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

    def self.configured_page_object
      Axe.configuration.page unless Axe.configuration.page.is_a?(String) || Axe.configuration.page.is_a?(Symbol)
    end

    def self.page_by_method_name(world)
      world.__send__(Axe.configuration.page) if world.respond_to?(Axe.configuration.page)
    end

    def self.page_by_ivar_name(world)
      if ivar_name = ([Axe.configuration.page.to_sym].concat(WEBDRIVER_NAMES) & world.instance_variables).first
        world.instance_variable_get(ivar_name)
      end
    end

  end
end
