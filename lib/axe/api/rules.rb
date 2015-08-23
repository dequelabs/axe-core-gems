module Axe
  module API
    class Rules
      def initialize
        @tags = []
        @included = []
        @excluded = []
        @exclusive = []
      end

      def according_to(*tags)
        @tags.concat tags.flatten
      end

      def checking(*rules)
        @included.concat rules.flatten
      end

      def checking_only(*rules)
        @exclusive.concat rules.flatten
      end

      def skipping(*rules)
        @excluded.concat rules.flatten
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
