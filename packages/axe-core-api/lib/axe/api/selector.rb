module Axe
  module API
    class Selector
      def self.normalize(s)
        if s.is_a? Hash
          if s.key? :iframe and s.key? :selector
            Array(Selector.new s)
          else
            s
          end
        else
          Array(Selector.new s)
        end
      end

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
