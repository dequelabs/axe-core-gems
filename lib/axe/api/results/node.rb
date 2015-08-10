require 'axe/api/value_object'

module Axe
  module API
    class Results
      class Node < ValueObject
        values do
          attribute :html, ::String
          attribute :target #String or Array[String]
        end

        def failure_message
          <<-MSG
          #{Array(target).join(', ')}
          #{html}
          MSG
        end
      end
    end
  end
end
