require 'axe/api'

module Axe
  module API
    #TODO test this class
    class A11yCheck
      def initialize(params)
        @context = params.fetch('context', Context.new)
        @options = params.fetch('options', Options.new)
      end

      def to_js
        "#{LIBRARY_IDENTIFIER}.a11yCheck(#{@context.to_json}, #{@options.to_json}, function(results){#{RESULTS_IDENTIFIER} = results;});"
      end
    end
  end
end
