require 'forwardable'
require 'pathname'
require 'rubygems'

require 'webdriver_script_adapter/execute_async_script_adapter'

module Axe
  class Configuration
    extend Forwardable

    HOOKS = [ :after_load ]

    attr_accessor :page, :core_jslib_path, :skip_iframes
    def_delegators ::WebDriverScriptAdapter,
      :async_results_identifier, :async_results_identifier=,
      :max_wait_time, :max_wait_time=,
      :wait_interval, :wait_interval=

    def initialize
      @page = :page
      @hooks = initialize_callbacks_array_per_hook
      @core_jslib_path = gem_root + 'node_modules/axe-core/axe.min.js'
    end

    # define run and registration methods per hook
    HOOKS.each do |hook|
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
      Hash[ HOOKS.map{|name| [name, []]} ]
    end

    def gem_root
      Pathname.new Gem::Specification.find_by_name('axe-matchers').gem_dir
    end
  end

  class NullWebDriver; end
end
