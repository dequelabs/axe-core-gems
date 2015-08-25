require 'axe/matchers'

module Axe
  module DSL
    class AccessibilityExpectation
      def initialize(page)
        @page = page
      end

      def to(matcher)
        @matcher = matcher
        assert
      end

      def to_not(matcher)
        @matcher = matcher
        refute
      end
      alias :not_to :to_not

      private

      def assert
        raise @matcher.failure_message unless @matcher.matches? @page
      end

      def refute
        raise @matcher.failure_message_when_negated if @matcher.matches? @page
      end
    end

    module_function

    include Matchers

    def expect(page)
      AccessibilityExpectation.new page
    end
  end
end
