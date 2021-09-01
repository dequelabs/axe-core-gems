require "forwardable"
require_relative "./rules"

module Axe
  module API
    class Options
      extend Forwardable

      def_delegators :@rules, :according_to, :checking, :checking_only, :skipping
      def_delegator :@custom, :merge!, :with_options

      def initialize
        @rules = Rules.new
        @custom = {}
      end

      def to_h
        to_hash
      end

      def to_hash
        @rules.to_hash.merge(@custom)
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
