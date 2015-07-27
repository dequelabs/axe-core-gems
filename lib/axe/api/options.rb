require 'forwardable'
require 'axe/api/rules'

module Axe
  module API
    class Options
      extend Forwardable

      def_delegator :@rules, :by_tags, :rules_by_tags
      def_delegator :@rules, :run_only, :run_only_rules
      def_delegator :@rules, :run, :run_rules
      def_delegator :@rules, :skip, :skip_rules
      def_delegator :@custom, :merge!, :custom_options

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
