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
          [ selector_message, node_html ]
        end

        private

        def selector_message
          "Selector: #{Array(target).join(', ')}"
        end

        def node_html
          "HTML: #{html.gsub(/^\s*|\n*/,'')}"
        end
      end
    end
  end
end
