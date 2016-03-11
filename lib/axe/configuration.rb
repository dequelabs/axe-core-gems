require 'forwardable'
require 'pathname'
require 'rubygems'
require 'singleton'
require 'yaml'

require 'axe/hooks'
require 'webdriver_script_adapter/execute_async_script_adapter'

module Axe
  class Configuration
    include Singleton
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

    class << self
      def from_yaml(path="config/axe.yml")
        file = Pathname.new(path)
        from_hash(YAML.load_file(file)) if file.exist?
        instance
      end

      def from_hash(attributes)
        attributes.each do |k, v|
          instance.__send__("#{k}=", v)
        end
        instance
      end
    end

    private

    def gem_root
      Gem::Specification.find_by_name('axe-matchers').gem_dir
    end
  end
end

Axe::Configuration.from_yaml
