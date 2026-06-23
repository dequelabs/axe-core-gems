require_relative "./value_object"

module Axe
  module API
    class Results < ValueObject
      require_relative "./results/rule"

      values do
        attribute :inapplicable, [Rule]
        attribute :incomplete, [Rule]
        attribute :passes, [Rule]
        attribute :timestamp
        attribute :testEngine
        attribute :testEnvironment
        attribute :testRunner
        attribute :toolOptions
        attribute :url, ::String
        attribute :violations, [Rule]
      end

      def failure_message
        [
          "",
          violation_count_message,
          "",
          violations_failure_messages,
        ].flatten.join("\n")
      end

      def to_h
        {
          inapplicable: inapplicable.map(&:to_h),
          incomplete: incomplete.map(&:to_h),
          passes: passes.map(&:to_h),
          testEngine: testEngine,
          timestamp: timestamp,
          url: url,
          violations: violations.map(&:to_h),
        }
      end

      def timestamp=(ts)
        @timestamp = ts
      end


      private

      def violation_count_message
        "Found #{violations.count} accessibility #{violations.count == 1 ? "violation" : "violations"}:"
      end

      def violations_failure_messages
        violations.each_with_index.map(&:failure_messages)
      end
    end
  end
end
