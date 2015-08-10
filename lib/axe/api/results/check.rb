require 'axe/api/value_object'
require 'axe/api/results/node'

module Axe
  module API
    class Results
      class Check < ValueObject
        values do
          attribute :id, ::Symbol
          attribute :impact, ::Symbol
          attribute :message, ::String
          attribute :data, ::String
          attribute :relatedNodes, ::Array[Node]
        end

        def failure_message
          <<-MSG
          #{message}
          MSG
        end
      end
    end
  end
end
