require 'forwardable'
require 'chain_mail/chainable'
require 'axe/page'
require 'axe/core'
require 'axe/api/a11y_check'

module Axe
  module Matchers
    class BeAccessible
      extend Forwardable
      def_delegators :@audit, :failure_message, :failure_message_when_negated
      def_delegators :@a11y_check, :within, :excluding, :according_to, :checking, :checking_only, :skipping, :with_options

      extend ChainMail::Chainable
      chainable :within, :excluding, :according_to, :checking, :checking_only, :skipping, :with_options

      def initialize
        @a11y_check = API::A11yCheck.new
      end

      def matches?(page)
        @audit = Core.new(Page.new page).call @a11y_check
        @audit.passed?
      end
    end

    module_function

    def be_accessible
      BeAccessible.new
    end
  end
end
