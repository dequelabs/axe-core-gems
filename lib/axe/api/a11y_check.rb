require 'forwardable'
require 'json'

require 'axe/api'
require 'axe/api/audit'
require 'axe/api/context'
require 'axe/api/options'
require 'axe/api/results'
require 'axe/javascript_library'

module Axe
  module API
    class A11yCheck
      METHOD_NAME = "#{LIBRARY_IDENTIFIER}.a11yCheck"

      extend Forwardable

      def_delegators :@context, :include, :exclude
      def_delegators :@options, :rules_by_tags, :run_rules, :skip_rules, :run_only_rules, :custom_options

      def initialize
        @context = Context.new
        @options = Options.new
      end

      def call(page)
        inject_axe_lib page
        audit page
      end

      private

      def inject_axe_lib(page)
        JavaScriptLibrary.new.inject_into page
      end

      def audit(page)
        Audit.new to_js, Results.new(execute_async(page))
      end

      def execute_async(page)
        page.execute_async_script "#{METHOD_NAME}.apply(#{LIBRARY_IDENTIFIER}, arguments)", @context.to_json, @options.to_json
      end

      def to_js
        "#{METHOD_NAME}(#{@context.to_json}, #{@options.to_json}, callback);"
      end
    end
  end
end
