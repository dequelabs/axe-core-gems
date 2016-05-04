require 'axe/api/value_object'
require 'axe/api/results/checked_node'

module Axe
  module API
    class Results
      class Rule < ValueObject
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
          [
            title_message(index+1),
            helpUrl.prepend(" " * 2),
            node_count_message
          ].concat(nodes.map(&:failure_message))
        end

        private

        def title_message(count)
          "#{count}) #{id}: #{help}"
        end

        def node_count_message
          "#{nodes.length} #{nodes.length == 1 ? 'node' : 'nodes'} were found with the violation:".insert(0, " " * 2)
        end
      end
    end
  end
end
