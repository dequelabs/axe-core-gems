require "singleton"
require "forwardable"
require "json"

require_relative "../hooks"
require_relative "../webdriver_script_adapter/execute_async_script_adapter"

module Axe
  class Configuration
    include Singleton
    include Common::Hooks
    extend Forwardable

    attr_writer :jslib
    attr_accessor :page,
                  :jslib_path,
                  :skip_iframes,
                  :legacy_mode
    def_delegators ::WebDriverScriptAdapter,
                   :async_results_identifier,
                   :async_results_identifier=,
                   :max_wait_time,
                   :max_wait_time=,
                   :wait_interval,
                   :wait_interval=

    # init
    def initialize
      @page = :page
      @skip_iframes = nil
      @jslib_path = get_root + "/node_modules/axe-core/axe.min.js"
    end

    # jslib
    def jslib
      @jslib ||= Pathname.new(@jslib_path).read
    end

    private

    def get_root
      Gem::Specification.find_by_name('axe-core-api').gem_dir
    end
  end
end
