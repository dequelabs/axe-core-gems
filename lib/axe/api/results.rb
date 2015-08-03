require 'ostruct'
require 'virtus'

module Axe
  module API
    #TODO maybe switch to Struct so field names can be defined/fixed
    class Results < OpenStruct
      class ValueObject
        include Virtus.value_object
      end
      # :url, :timestamp, :passes, :violations

      attr_accessor :invocation

      def self.from_hash(results)
        new(results.dup.tap {|r|
          r['passes'] = r.fetch('passes', []).map { |p| Rule.new p }
          r['violations'] = r.fetch('violations', []).map { |v| Rule.new v }
        })
      end

      def passed?
        violations.count == 0
      end

      def failure_message
        if passed?
          <<-MSG.gsub(/^\s*/,'')
          Expected to find accessibility violations. None were detected.
          Invocation: #{invocation}
          MSG
        else
          <<-MSG.gsub(/^\s*/,'')
          Found #{violations.count} accessibility #{violations.count == 1 ? 'violation' : 'violations'}
          Invocation: #{invocation}
          #{ violations.each_with_index.map(&:failure_message).join("\n\n") }
          MSG
        end
      end

      # nested because the 'rule' concept is different when outside of Results

      class Node < ValueObject
        values do
          attribute :html
          attribute :target
        end

        def failure_message
          <<-MSG
          #{Array(target).join(', ')}
          #{html}
          MSG
        end
      end

      class Check < ValueObject
        values do
          attribute :id, Symbol
          attribute :impact, Symbol
          attribute :message
          attribute :data
          attribute :relatedNodes, Array[Node]
        end

        def failure_message
          <<-MSG
          #{message}
          MSG
        end
      end

      class CheckedNode < Node
        values do
          attribute :impact, Symbol
          attribute :any, Array[Check]
          attribute :all, Array[Check]
          attribute :none, Array[Check]
        end

        def failure_message
          <<-MSG
          #{super}
          #{[].concat(any).concat(all).map(&:failure_message).join("\n")}
          MSG
        end
      end

      class Rule < ValueObject
        values do
          attribute :id, Symbol
          attribute :description
          attribute :help
          attribute :helpUrl
          attribute :impact, Symbol
          attribute :tags, Array[Symbol]
          attribute :nodes, Array[CheckedNode]
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
