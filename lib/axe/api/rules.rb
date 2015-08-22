module Axe
  module API
    class Rules
      attr_reader :tags, :included, :excluded, :exclusive

      def initialize
        @tags = []
        @included = []
        @excluded = []
        @exclusive = []
      end

      def by_tags(*tags)
        @tags.concat tags.flatten
        self
      end

      def run_only(*rules)
        @exclusive.concat rules.flatten
        self
      end

      def run(*rules)
        @included.concat rules.flatten
        self
      end

      def skip(*rules)
        @excluded.concat rules.flatten
        self
      end

      def to_hash
        {}.tap do |options|
          #TODO warn that tags + exclusive-rules are incompatible
          options.merge! runOnly: { type: :tag, values: @tags } unless @tags.empty?
          options.merge! runOnly: { type: :rule, values: @exclusive } unless @exclusive.empty?
          options.merge! rules: Hash[@included.product([enabled: true]) + @excluded.product([enabled: false])] unless @included.empty? && @excluded.empty?
        end
      end
    end
  end
end
