module Axe
  module API
    class Selector
      def initialize(s)
        @selector = case s
                    when Array then s
                    when String, Symbol then [String(s)]
                    when Hash then Selector.new(s[:selector]).to_a.unshift s[:iframe]
                    else Selector.new(s.selector).to_a.unshift s.iframe
                    end
      end

      def to_a
        @selector
      end
    end
  end
end
