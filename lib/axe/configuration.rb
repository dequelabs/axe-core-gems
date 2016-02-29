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

    @@hooks = [ :after_load ]

    def initialize
      @hooks = initialize_callbacks_array_per_hook
    end

    def api
      @api ||= API.new self
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

    # define hook registration methods
    @@hooks.each do |hook|
      define_method hook do |callable=nil, &block|
        callable ||= block
        @hooks.fetch(hook) << callable if callable
      end
    end

    private

    def initialize_callbacks_array_per_hook
      Hash[ @@hooks.map{|name| [name, []]} ]
    end

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

    # adapter to only expose public methods to Axe.configure block
    class API
      extend Forwardable

      def_delegators :@configuration,
        :async_results_identifier, :async_results_identifier=,
        :max_wait_time, :max_wait_time=,
        :page, :page=,
        :wait_interval, :wait_interval=

      def initialize(configuration)
        @configuration = configuration
      end
    end
  end

  class NullWebDriver; end
end
