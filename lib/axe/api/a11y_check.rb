require 'forwardable'
require 'json'

require 'axe/api'
require 'axe/api/context'
require 'axe/api/options'

module Axe
  module API
    class A11yCheck
      extend Forwardable

      def_delegators :@context, :include, :exclude
      def_delegators :@options, :rules_by_tags, :run_only_rules

      def initialize
        @context = Context.new
        @options = Options.new
      end

      def to_js
        "#{LIBRARY_IDENTIFIER}.a11yCheck(#{@context.to_json}, #{@options.to_json}, function(results){#{RESULTS_IDENTIFIER} = results;});"
      end
    end
  end
end
