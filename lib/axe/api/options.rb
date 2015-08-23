require 'forwardable'
require 'axe/api/rules'

module Axe
  module API
    class Options
      extend Forwardable

      def_delegators :@rules, :according_to, :checking, :checking_only, :skipping
      def_delegator :@custom, :merge!, :with_options

      attr_reader :rules, :custom

      def initialize
        @rules = Rules.new
        @custom = {}
      end

      def to_hash
        @rules.to_hash.merge(@custom)
      end

      def to_json
        to_hash.to_json
      end

      alias :to_s :to_json

    end
  end
end
