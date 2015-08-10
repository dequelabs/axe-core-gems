require 'virtus'
require 'axe/api/results/checked_node'

module Axe
  module API
    class Results
      class Rule
        include ::Virtus.value_object mass_assignment: false

        values do
          attribute :id, ::Symbol
          attribute :description, ::String
          attribute :help, ::String
          attribute :helpUrl, ::String
          attribute :impact, ::Symbol
          attribute :tags, ::Array[::Symbol]
          attribute :nodes, ::Array[CheckedNode]
        end

        def failure_message(index)
          <<-MSG
          #{index+1}) #{help}: #{helpUrl}
          #{nodes.map(&:failure_message).join("\n")}
          MSG
        end
      end
    end
  end
end
