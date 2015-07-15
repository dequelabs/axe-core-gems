require 'forwardable'

module Axe
  module API
    class Context
      extend Forwardable

      attr_reader :inclusion, :exclusion
      def_delegator :context_parameter, :to_json

      def initialize
        @inclusion = []
        @exclusion = []
      end

      def include(selector)
        @inclusion.concat to_array(selector)
        self
      end

      def exclude(selector)
        @exclusion.concat to_array(selector)
        self
      end

      private

      def context_parameter
        {}.tap do |context_param|
          # include key must not be included if empty
          # (when undefined, defaults to `document`)
          context_param[:include] = @inclusion unless @inclusion.empty?

          # exclude array allowed to be empty
          # and must exist in case `include` is omitted
          # because context_param cannot be empty object ({})
          context_param[:exclude] = @exclusion
        end
      end

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
