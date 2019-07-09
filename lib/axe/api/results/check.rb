require 'axe/api/value_object'
require 'axe/api/results/node'

module Axe
  module API
    class Results
      class Check < ValueObject
        values do
          attribute :data, ::String
          attribute :id, ::Symbol
          attribute :impact, ::Symbol
          attribute :message, ::String
          attribute :relatedNodes, ::Array[Node]
        end

        def failure_message
          message
        end

        def to_h
          {
            data: data,
            id: id,
            impact: impact,
            message: message,
            relatedNodes: relatedNodes.map(&:to_h)
          }
        end
      end
    end
  end
end
