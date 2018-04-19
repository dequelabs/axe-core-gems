require 'axe/api/results/node'
require 'axe/api/results/check'

module Axe
  module API
    class Results
      class CheckedNode < Node
        values do
          attribute :impact, ::Symbol
          attribute :any, ::Array[Check]
          attribute :all, ::Array[Check]
          attribute :none, ::Array[Check]
        end

        def failure_messages
          [
            super,
            fix(all, "Fix all of the following:"),
            fix(none, "Fix all of the following:"),
            fix(any, "Fix any of the following:"),
          ]
        end

        def to_h
          {
            impact: impact,
            any: any.map(&:to_h),
            all: all.map(&:to_h),
            none: none.map(&:to_h)
          }
        end

        private

        def fix(checks, message)
          valid_checks = checks.reject{|c| c.nil?}
          [
            (message unless valid_checks.empty?),
            valid_checks.map(&:failure_message).map{|line| line.prepend("- ") }
          ].compact
        end
      end
    end
  end
end
