require 'forwardable'
require 'pathname'
require 'rubygems'

require 'axe/hooks'
require 'webdriver_script_adapter/execute_async_script_adapter'

module Axe
  class Configuration
    include Hooks
    extend Forwardable

    attr_accessor :page, :jslib, :jslib_path, :skip_iframes
    def_delegators ::WebDriverScriptAdapter,
      :async_results_identifier, :async_results_identifier=,
      :max_wait_time, :max_wait_time=,
      :wait_interval, :wait_interval=

    def initialize
      @page = :page
      @jslib_path = gem_root + '/node_modules/axe-core/axe.min.js'
    end

    def jslib
      @jslib ||= Pathname.new(@jslib_path).read
    end

    private

    def gem_root
      Gem::Specification.find_by_name('axe-matchers').gem_dir
    end
  end
end
