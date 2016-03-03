require 'axe'

module Axe
  module Support

    module_function

    def page_from(world)
      configured_page_object ||
        page_by_name(Axe.configuration.page, world) ||
        page_by_name(:@page, world) ||
        page_by_name(:@browser, world) ||
        page_by_name(:@driver, world) ||
        page_by_name(:@webdriver, world) ||
        NullWebDriver.new
    end

    private

    def self.configured_page_object
      Axe.configuration.page unless Axe.configuration.page.is_a?(String) || Axe.configuration.page.is_a?(Symbol)
    end

    def self.page_by_name(page, world)
      if world.respond_to? page
        world.__send__(page)
      else
        world.instance_variable_get(page) rescue nil
      end
    end

  end
end
