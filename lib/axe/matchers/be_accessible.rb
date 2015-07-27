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
        @context = API::Context.new
        @options = API::Options.new
      end

      def matches?(page)
        @results = API::Audit.new(page).run(context: @context, options: @options)

        @results.passed?
      end

      def within(inclusion)
        @context.include inclusion
        self
      end

      def excluding(exclusion)
        @context.exclude exclusion
        self
      end

      def for_tag(*tags)
        @options.rules_by_tags(tags.flatten)
        self
      end
      alias :for_tags :for_tag

      def for_rule(*rules)
        @options.run_only_rules(rules.flatten)
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
