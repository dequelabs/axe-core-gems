require 'forwardable'
require 'axe/page'
require 'axe/api/a11y_check'

module Axe
  module Matchers
    class BeAccessible
      extend Forwardable

      def_delegator :@results, :failure_message
      def_delegator :@results, :failure_message, :failure_message_when_negated

      def initialize
        @a11y_check = API::A11yCheck.new
      end

      def matches?(page)
        @results = @a11y_check.call Page.new page

        @results.passed?
      end

      def within(inclusion)
        @a11y_check.include inclusion
        self
      end

      def excluding(exclusion)
        @a11y_check.exclude exclusion
        self
      end

      def according_to(*tags)
        @a11y_check.rules_by_tags tags.flatten
        self
      end

      def checking(*rules)
        @a11y_check.run_rules rules.flatten
        self
      end

      def skipping(*rules)
        @a11y_check.skip_rules rules.flatten
        self
      end

      def checking_only(*rules)
        @a11y_check.run_only_rules rules.flatten
        self
      end

      def with_options(options)
        @a11y_check.custom_options options
        self
      end
    end

    def be_accessible
      BeAccessible.new
    end
  end
end
