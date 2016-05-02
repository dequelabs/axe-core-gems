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

        def failure_message
          super.concat([].concat(any).concat(all).map(&:failure_message))
        end
      end
    end
  end
end
