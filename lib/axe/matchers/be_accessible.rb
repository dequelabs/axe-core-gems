require 'json'
require 'forwardable'
require 'axe/page'
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
        @page = Page.new(page)

        API::Audit.new(@page).run(context: @context, options: @options)
        parse_audit_results

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

      private

      def parse_audit_results
        @results = API::Results.from_hash audit_results
      end

      def audit_results
        @page.wait_until { @page.evaluate(API::RESULTS_IDENTIFIER) }
      end
    end

    def be_accessible
      BeAccessible.new
    end
  end
end
