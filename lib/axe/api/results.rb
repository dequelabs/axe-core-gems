require 'axe/api/value_object'

module Axe
  module API
    class Results < ValueObject
      require 'axe/api/results/rule'

      values do
        attribute :url, ::String
        attribute :timestamp
        attribute :passes, ::Array[Rule]
        attribute :violations, ::Array[Rule]
      end

      def failure_message
        [ violation_count_message ].concat(violations_failure_messages).join("\n")
      end

      private

      def violation_count_message
        "Found #{violations.count} accessibility #{violations.count == 1 ? 'violation' : 'violations'}:\n"
      end

      def violations_failure_messages
        violations.each_with_index.map(&:failure_message)
      end
    end
  end
end
