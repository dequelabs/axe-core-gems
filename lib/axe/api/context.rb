require 'axe/api/selector'

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
        {}.tap do |context_param|
          # omit empty arrays
          # (include must not be present if empty)
          # (exclude is allowed to be empty; but meh)
          context_param[:include] = @inclusion unless @inclusion.empty?
          context_param[:exclude] = @exclusion unless @exclusion.empty?
        end
      end

      def to_json
        to_hash.to_json
      end

      alias :to_s :to_json
    end
  end
end
