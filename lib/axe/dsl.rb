require 'axe/matchers'

module Axe
  module DSL
    class AccessibleExpectation
      def self.assert(page, matcher)
        raise matcher.failure_message unless matcher.matches? page
      end
    end

    class InaccessibleExpectation
      def self.assert(page, matcher)
        raise matcher.failure_message_when_negated if matcher.matches? page
      end
    end

    class AccessibilityExpectation
      def initialize(page)
        @page = page
      end

      def to(matcher)
        AccessibleExpectation.assert @page, matcher
      end

      def to_not(matcher)
        InaccessibleExpectation.assert @page, matcher
      end
      alias :not_to :to_not
    end

    module_function

    # get the be_accessible matcher method
    extend Matchers

    def expect(page)
      AccessibilityExpectation.new page
    end
  end
end
