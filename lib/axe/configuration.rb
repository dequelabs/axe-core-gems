require 'forwardable'
require 'pathname'
require 'rubygems'

require 'webdriver_script_adapter/execute_async_script_adapter'

module Axe
  class Configuration
    extend Forwardable

    attr_accessor :page, :core_jslib_path
    def_delegators ::WebDriverScriptAdapter,
      :async_results_identifier, :async_results_identifier=,
      :max_wait_time, :max_wait_time=,
      :wait_interval, :wait_interval=

    @@hooks = [ :after_load ]
    def self.hooks
      @@hooks
    end

    def initialize
      @hooks = initialize_callbacks_array_per_hook
      @core_jslib_path = gem_root + 'node_modules/axe-core/axe.min.js'
    end

    def api
      @api ||= DSL.new self
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

    # define run and registration methods per hook
    @@hooks.each do |hook|
      define_method hook do |callable=nil, &block|
        callable ||= block
        @hooks.fetch(hook) << callable if callable
      end

      define_method "run_#{hook}_hook" do |*args|
        @hooks.fetch(hook).each do |callback|
          callback.call(*args)
        end
      end
    end

    private

    def initialize_callbacks_array_per_hook
      Hash[ @@hooks.map{|name| [name, []]} ]
    end

    def gem_root
      Pathname.new Gem::Specification.find_by_name('axe-matchers').gem_dir
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
    # Only the methods that are on this object are exposed to:
    #     Axe.configure do |c|
    #       c.*
    #     end
    # They are all forwarded to the internal @configuration instance
    class DSL
      extend Forwardable

      def_delegators :@configuration,
        :async_results_identifier=,
        :core_jslib_path=,
        :max_wait_time=,
        :page=,
        :wait_interval=,
        *Configuration.hooks

      def initialize(configuration)
        @configuration = configuration
      end
    end
  end

  class NullWebDriver; end
end
