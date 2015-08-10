require 'axe/api/value_object'

module Axe
  module API
    class Results < ValueObject
      require 'axe/api/results/rule'

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
