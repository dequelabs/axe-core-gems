module Axe
  module API
    class Rules
      attr_reader :tags, :included, :excluded

      def initialize
        @tags = []
        @included = []
        @excluded = []
      end

      def by_tag(*tags)
        @tags += tags.flatten
        self
      end

      def run(*rules)
        @included += rules.flatten
        self
      end

      def skip(*rules)
        @excluded += rules.flatten
        self
      end

      def to_json
        {
          rules: Hash[@included.product([enabled: true]) + @excluded.product([enabled: false])]
        }.to_json
      end
    end
  end
end
