require 'forwardable'
require 'webdriver_script_adapter/execute_async_script_adapter'

module Axe
  class Configuration
    extend Forwardable

    attr_accessor :page
    def_delegators ::WebDriverScriptAdapter, :max_wait_time, :max_wait_time=

    def page_from(world)
      page_from_eval(world) ||
        page ||
        default_page_from(world) ||
        from_ivar(:@page, world) ||
        from_ivar(:@browser, world) ||
        from_ivar(:@driver, world) ||
        from_ivar(:@webdriver, world) ||
        NullWebDriver.new
    end

    private

    def page_from_eval(world)
      world.instance_eval "#{page}" if page.is_a?(String) || page.is_a?(Symbol)
    end

    def default_page_from(world)
      world.page if world.respond_to? :page
    end

    def from_ivar(ivar, world)
      self.page = ivar
      page_from_eval(world)
    end
  end

  class NullWebDriver; end
end
