module Axe
  module API
    class Context
      attr_reader :inclusion

      def initialize
        @inclusion = []
      end

      def include(selector)
        @inclusion.concat to_array(selector)
      end

      private

      def to_array(selector)
        Array(make_arrayable(selector)).map { |s| Array(s) }
      end

      def make_arrayable(selector)
        selector.extend(ToArray)
      end
    end
  end
end

module ToArray
  def to_a
    self.split(/,\s*/)
  end
end
