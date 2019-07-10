module Axe
  module API
    class Audit
      attr_reader :invocation, :results

      def initialize(invocation, results)
        @invocation = invocation
        @results = results
      end

      def passed?
        results.violations.count == 0
      end

      def failure_message
        "#{results.failure_message}\nInvocation: #{invocation}"
      end

      def failure_message_when_negated
        "Expected to find accessibility violations. None were detected.\n\nInvocation: #{invocation}"
      end
    end
  end
end
