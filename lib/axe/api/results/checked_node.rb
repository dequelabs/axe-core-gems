require 'virtus'
require 'axe/api/results/node'
require 'axe/api/results/check'

module Axe
  module API
    class Results
      class CheckedNode < Node
        include ::Virtus.value_object mass_assignment: false

        values do
          attribute :impact, ::Symbol
          attribute :any, ::Array[Check]
          attribute :all, ::Array[Check]
          attribute :none, ::Array[Check]
        end

        def failure_message
          <<-MSG
          #{super}
          #{[].concat(any).concat(all).map(&:failure_message).join("\n")}
          MSG
        end
      end
    end
  end
end
