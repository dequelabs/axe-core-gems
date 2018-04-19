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

        def failure_messages(index)
          [
            title_message(index+1),
            *[
              helpUrl,
              node_count_message,
              "",
              nodes.reject{|n| n.nil?}.map(&:failure_messages).map{|n| n.push("")}.flatten.map(&indent)

            ].flatten.map(&indent)
          ]
        end

        def to_h
          {
            id: id,
            description: description,
            help: help,
            helpUrl: helpUrl,
            impact: impact,
            tags: tags,
            nodes: nodes.map(&:to_h)
          }
        end

        private

        def indent
          -> (line) { line.prepend(" " * 4) unless line.nil? }
        end

        def title_message(count)
          "#{count}) #{id}: #{help} (#{impact})"
        end

        def node_count_message
          "The following #{nodes.length} #{nodes.length == 1 ? 'node' : 'nodes'} violate this rule:"
        end
      end
    end
  end
end
