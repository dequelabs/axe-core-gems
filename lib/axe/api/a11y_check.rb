require 'forwardable'
require 'json'

require 'axe/api'
require 'axe/api/context'
require 'axe/api/options'
require 'axe/api/results'
require 'axe/javascript_library'

module Axe
  module API
    class A11yCheck
      METHOD_NAME = "a11yCheck"

      extend Forwardable

      def_delegators :@context, :include, :exclude
      def_delegators :@options, :rules_by_tags, :run_rules, :skip_rules, :run_only_rules, :custom_options

      def initialize
        @context = Context.new
        @options = Options.new
      end

      def call(page)
        inject_axe_lib page

        parse_results audit(page)
      end

      private

      def inject_axe_lib(page)
        JavaScriptLibrary.new.inject_into page
      end

      def audit(page)
        page.exec_async "#{LIBRARY_IDENTIFIER}.#{METHOD_NAME}.apply(#{LIBRARY_IDENTIFIER}, arguments)", @context.to_json, @options.to_json
      end

      def parse_results(results)
        Results.new(results).tap do |r|
          r.invocation = to_js
        end
      end

      def to_js
        "#{LIBRARY_IDENTIFIER}.#{METHOD_NAME}(#{@context.to_json}, #{@options.to_json}, callback);"
      end
    end
  end
end
