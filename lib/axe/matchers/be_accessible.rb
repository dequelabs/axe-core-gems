require 'json'
require 'forwardable'
require 'axe/api'

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

      def for_tag(*tags)
        @audit.rules_by_tags(tags.flatten)
        self
      end
      alias :for_tags :for_tag

      def for_rule(*rules)
        @audit.run_only_rules(rules.flatten)
        self
      end
      alias :for_rules :for_rule

      def with_options(options)
        @options = options
        self
      end
    end

    def be_accessible
      BeAccessible.new
    end
  end
end
