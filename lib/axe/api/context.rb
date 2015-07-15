module Axe
  module API
    class Context
      attr_reader :inclusion, :exclusion

      def initialize
        @inclusion = []
        @exclusion = []
      end

      def include(selector)
        @inclusion.concat to_array(selector)
      end

      def exclude(selector)
        @exclusion.concat to_array(selector)
      end

      private

      def to_array(selector)
        Array(make_arrayable(selector)).map { |s| Array(s) }
      end

      def make_arrayable(selector)
        selector.extend(ToArray)
      end

      module ToArray
        def to_a
          self.split(/,\s*/)
        end
      end

    end
  end
end
