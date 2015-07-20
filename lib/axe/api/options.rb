require 'forwardable'
require 'axe/api/rules'

module Axe
  module API
    class Options
      extend Forwardable

      def_delegator :@rules, :by_tag, :rules_by_tag
      def_delegator :@rules, :run, :run_rules
      def_delegator :@rules, :skip, :skip_rules
      def_delegator :@custom, :merge!, :add

      attr_reader :rules, :custom

      def initialize
        @rules = Rules.new
        @custom = {}
      end

      def to_json
        @rules.to_hash.merge(@custom).to_json
      end

    end
  end
end
