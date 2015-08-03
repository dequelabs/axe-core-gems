require 'ostruct'
require 'virtus'

module Axe
  module API
    #TODO maybe switch to Struct so field names can be defined/fixed
    class Results < OpenStruct
      # :url, :timestamp, :passes, :violations

      attr_accessor :invocation

      def self.from_hash(results)
        new(results.dup.tap {|r|
          r['passes'] = r.fetch('passes', []).map { |p| Rule.from_hash p }
          r['violations'] = r.fetch('violations', []).map { |v| Rule.from_hash v }
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

      class Rule < OpenStruct
        # :description, :help, :help_url, :id, :impact, :tags, :nodes

        def self.from_hash(rule)
          new(rule.dup.tap {|r|
            r['help_url'] = r.delete('helpUrl')
            r['nodes'] = r.fetch('nodes', []).map { |n| CheckedNode.new n }
          })
        end

        def failure_message(index)
          <<-MSG
          #{index+1}) #{help}: #{help_url}
          #{nodes.map(&:failure_message).join("\n")}
          MSG
        end

      end

      class Node
        include Virtus.value_object

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

      class Check
        include Virtus.value_object

        values do
          attribute :id
          attribute :impact
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
          attribute :impact
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

    end
  end
end
