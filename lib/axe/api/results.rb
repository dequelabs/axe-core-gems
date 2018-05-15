require 'axe/api/value_object'

module Axe
  module API
    class Results < ValueObject
      require 'axe/api/results/rule'

      values do
        attribute :inapplicable, ::Array[Rule]
        attribute :incomplete, ::Array[Rule]
        attribute :passes, ::Array[Rule]
        attribute :timestamp
        attribute :url, ::String
        attribute :violations, ::Array[Rule]
      end

      def failure_message
        [
          "",
          violation_count_message,
          "",
          violations_failure_messages
        ].flatten.join("\n")
      end

      def to_h
        {
          inapplicable: inapplicable.map(&:to_h),
          incomplete: incomplete.map(&:to_h),
          passes: passes.map(&:to_h),
          timestamp: timestamp,
          url: url,
          violations: violations.map(&:to_h),
        }
      end

      private

      def violation_count_message
        "Found #{violations.count} accessibility #{violations.count == 1 ? 'violation' : 'violations'}:"
      end

      def violations_failure_messages
        violations.each_with_index.map(&:failure_messages)
      end
    end
  end
end
