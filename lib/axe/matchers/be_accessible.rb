require 'forwardable'
require 'axe/api/audit'

module Axe
  module Matchers
    class BeAccessible
      extend Forwardable

      def_delegator :@results, :failure_message
      def_delegator :@results, :failure_message, :failure_message_when_negated

      def initialize
        @audit = API::Audit.new
      end

      def matches?(page)
        @results = @audit.run_against(page)

        @results.passed?
      end

      def within(inclusion)
        @audit.include inclusion
        self
      end

      def excluding(exclusion)
        @audit.exclude exclusion
        self
      end

      def according_to(*tags)
        @audit.rules_by_tags tags.flatten
        self
      end

      def for_rule(*rules)
        @audit.run_only_rules rules.flatten
        self
      end
      alias :for_rules :for_rule

      def with_options(options)
        @audit.custom_options options
        self
      end
    end

    def be_accessible
      BeAccessible.new
    end
  end
end
