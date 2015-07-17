require 'ostruct'

module Axe
  module API
    class Results < OpenStruct
      # :url, :timestamp, :passes, :violations

      def self.from_hash(results)
        results['passes'] = results['passes'].map { |p| Rule.from_hash p }
        results['violations'] = results['violations'].map { |v| Rule.from_hash v }
        new results
      end

      def passed?
        violations.count == 0
      end

      def message
        <<-MSG.gsub(/^\s*/,'')
        Found #{violations.count} accessibility #{violations.count == 1 ? 'violation' : 'violations'}:
        #{ violations.each_with_index.map(&:message).join("\n") }
        MSG
      end

      # nested because the 'rule' concept is different outside of Results
      class Rule < OpenStruct
        # :description, :help, :help_url, :id, :impact, :tags, :nodes

        def self.from_hash(rule)
          rule['help_url'] = rule.delete('helpUrl')
          rule['nodes'] = rule['nodes'].map { |n| Node.from_hash n }
          new rule
        end

        def message(index)
          <<-MSG
          #{index+1}) #{help}: #{help_url}
          #{nodes.map(&:message).join("\n")}
          MSG
        end

      end

      class Node < OpenStruct

        def self.from_hash(node)
          new node
        end

        def message
          <<-MSG
          #{target.join(',')}
          #{html}
          MSG
        end
      end
    end
  end
end
