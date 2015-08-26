require 'forwardable'
require 'axe/page'
require 'axe/api/a11y_check'

module Axe
  module Matchers
    class BeAccessible
      extend Forwardable

      def_delegators :@audit, :failure_message, :failure_message_when_negated

      def initialize
        @a11y_check = API::A11yCheck.new
      end

      def matches?(page)
        @audit = @a11y_check.call Page.new page

        @audit.passed?
      end

      def within(*inclusion)
        @a11y_check.within(*inclusion)
        self
      end

      def excluding(*exclusion)
        @a11y_check.excluding(*exclusion)
        self
      end

      def according_to(*tags)
        @a11y_check.according_to(*tags)
        self
      end

      def checking(*rules)
        @a11y_check.checking(*rules)
        self
      end

      def skipping(*rules)
        @a11y_check.skipping(*rules)
        self
      end

      def checking_only(*rules)
        @a11y_check.checking_only(*rules)
        self
      end

      def with_options(options)
        @a11y_check.with_options options
        self
      end
    end

    def be_accessible
      BeAccessible.new
    end
  end
end
