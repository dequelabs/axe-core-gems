require_relative "./selector"

module Axe
  module API
    class Context
      def initialize
        @inclusion = []
        @exclusion = []
      end

      def within(*selectors)
        @inclusion.concat selectors.map { |s| Array(Selector.new s) }
      end

      def excluding(*selectors)
        @exclusion.concat selectors.map { |s| Array(Selector.new s) }
      end

      def to_hash
        { include: @inclusion, exclude: @exclusion }
          .reject { |k, v| v.empty? }
      end

      def to_json
        to_hash.to_json
      end

      def empty?
        to_hash.empty?
      end

      alias :to_s :to_json
    end
  end
end
