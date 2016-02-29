require 'forwardable'
require 'webdriver_script_adapter/execute_async_script_adapter'

module Axe
  class Configuration
    extend Forwardable

    attr_accessor :page
    def_delegators ::WebDriverScriptAdapter,
      :async_results_identifier, :async_results_identifier=,
      :max_wait_time, :max_wait_time=,
      :wait_interval, :wait_interval=

    def initialize
      @hooks = { after_load: [] }
    end

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

    def run_hook(name, *args)
      @hooks.fetch(name).each do |callback|
        callback.call(*args)
      end
    end

    # hooks

    def after_load(callable=nil, &block)
      callable ||= block
      @hooks.fetch(:after_load) << callable if callable
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
