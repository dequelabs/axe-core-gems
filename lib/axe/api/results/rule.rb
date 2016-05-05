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
            *[
              helpUrl,
              node_count_message,
              "",
              nodes.map(&:failure_message).map{|n| n.push("")}.flatten.map(&indent)

            ].flatten.map(&indent)
          ]
        end

        private

        def indent
          -> (line) { line.prepend(" " * 4) }
        end

        def title_message(count)
          "#{count}) #{id}: #{help}"
        end

        def node_count_message
          "The following #{nodes.length} #{nodes.length == 1 ? 'node' : 'nodes'} violate this rule:"
        end
      end
    end
  end
end
