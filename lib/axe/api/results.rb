require 'virtus'
require 'axe/api/results/rule'

module Axe
  module API
    class Results
      include ::Virtus.value_object

      values do
        attribute :url, ::String
        attribute :timestamp
        attribute :passes, ::Array[Rule]
        attribute :violations, ::Array[Rule]
      end

      def failure_message
        <<-MSG.gsub(/^\s*/,'')
        Found #{violations.count} accessibility #{violations.count == 1 ? 'violation' : 'violations'}
        #{ violations.each_with_index.map(&:failure_message).join("\n\n") }
        MSG
      end
    end
  end
end
