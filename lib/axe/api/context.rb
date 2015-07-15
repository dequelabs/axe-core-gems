require 'json'

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

      def to_js
        JSON.generate context_parameter
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
