require 'forwardable'
require 'chain_mail/chainable'
require 'axe/core'
require 'axe/api/run'

module Axe
  module Matchers
    class BeAccessible
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

    def be_accessible
      BeAccessible.new
    end
  end
end
