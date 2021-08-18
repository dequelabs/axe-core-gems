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
        return { exclude: @exclusion } if @inclusion.empty?
        h = {}
        h["include"] = @inclusion unless @inclusion.empty?
        h["exclude"] = @exclusion unless @exclusion.empty?
        h
      end

      def to_json(options = nil)
        to_hash.to_json options
      end

      def empty?
        to_hash.empty?
      end

      alias :to_s :to_json
    end
  end
end
