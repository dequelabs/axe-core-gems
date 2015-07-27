require 'axe/api'

module Axe
  module API
    #TODO test this class
    class A11yCheck
      def initialize(params)
        @context = params.fetch('context')
        @options = params.fetch('options')
      end

      def to_js
        "#{LIBRARY_IDENTIFIER}.a11yCheck(#{@context.to_json}, #{@options.to_json}, function(results){#{RESULTS_IDENTIFIER} = results;});"
      end
    end
  end
end
