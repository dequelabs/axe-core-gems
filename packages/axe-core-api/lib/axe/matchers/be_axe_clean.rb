require "forwardable"

require_relative "../../chain_mail/chainable"
require_relative "../core"
require_relative "../api"

module Axe
  module Matchers
    class BeAxeClean
      extend Forwardable
      def_delegators :@audit, :failure_message, :failure_message_when_negated
      def_delegators :@run, :within, :excluding, :according_to, :checking, :checking_only, :skipping, :with_options

      extend ChainMail::Chainable
      chainable :within, :excluding, :according_to, :checking, :checking_only, :skipping, :with_options

      def initialize
        @run = API::Run.new
      end

      def audit(page)
        @audit ||= Core.new(page).call @run
      end

      def matches?(page)
        audit(page).passed?
      end
    end

    module_function

    def be_axe_clean
      BeAxeClean.new
    end
  end
end
