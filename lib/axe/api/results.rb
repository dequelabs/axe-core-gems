require 'ostruct'

module Axe
  module API
    class Results < OpenStruct
      # :url, :timestamp, :passes, :violations

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
          "Expected to find accessibility violations. None were detected."
        else
          <<-MSG.gsub(/^\s*/,'')
          Found #{violations.count} accessibility #{violations.count == 1 ? 'violation' : 'violations'}:
          #{ violations.each_with_index.map(&:failure_message).join("\n") }
          MSG
        end
      end

      # nested because the 'rule' concept is different when outside of Results

      class Rule < OpenStruct
        # :description, :help, :help_url, :id, :impact, :tags, :nodes

        def self.from_hash(rule)
          new(rule.dup.tap {|r|
            r['help_url'] = r.delete('helpUrl')
            r['nodes'] = r.fetch('nodes', []).map { |n| Node.from_hash n }
          })
        end

        def failure_message(index)
          <<-MSG
          #{index+1}) #{help}: #{help_url}
          #{nodes.map(&:failure_message).join("\n")}
          MSG
        end

      end

      class Node < OpenStruct
        # :html, :impact, :target, :any, :all, :none

        def self.from_hash(node)
          new(node.dup.tap {|n|
            n['any'] = n.fetch('any', []).map { |c| Check.from_hash c }
            n['all'] = n.fetch('all', []).map { |c| Check.from_hash c }
            n['none'] = n.fetch('none', []).map { |c| Check.from_hash c }
          })
        end

        def failure_message
          <<-MSG
          #{target.join(', ')}
          #{html}
          #{[].concat(any).concat(all).map(&:failure_message).join("\n")}
          MSG
        end
      end

      class Check < OpenStruct
        # :id, :impact, :message, :data, :html

        def self.from_hash(node)
          new node
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
