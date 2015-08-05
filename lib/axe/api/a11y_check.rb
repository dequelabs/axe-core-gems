require 'forwardable'
require 'json'

require 'axe/api'
require 'axe/api/context'
require 'axe/api/options'
require 'axe/api/results'

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
        Results.new(audit(page)).tap do |results|
          results.invocation = to_js
        end

      end

      private

      def audit(page)
        page.exec_async "#{LIBRARY_IDENTIFIER}.#{METHOD_NAME}.apply(#{LIBRARY_IDENTIFIER}, arguments)", @context.to_json, @options.to_json
      end

      def to_js
        "#{LIBRARY_IDENTIFIER}.#{METHOD_NAME}(#{@context.to_json}, #{@options.to_json}, callback);"
      end
    end
  end
end
