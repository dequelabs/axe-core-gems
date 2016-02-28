require 'forwardable'
require 'json'

require 'chain_mail/chainable'

require 'axe/api'
require 'axe/api/audit'
require 'axe/api/context'
require 'axe/api/options'
require 'axe/api/results'
require 'axe/core'

module Axe
  module API
    class A11yCheck
      JS_NAME = "a11yCheck"
      METHOD_NAME = "#{Core::JS_NAME}.#{JS_NAME}"

      extend Forwardable
      def_delegators :@context, :within, :excluding
      def_delegators :@options, :according_to, :checking, :checking_only, :skipping, :with_options

      extend ChainMail::Chainable
      chainable :within, :excluding, :according_to, :checking, :checking_only, :skipping, :with_options

      def initialize
        @context = Context.new
        @options = Options.new
      end

      def call(page)
        Core.new(page)
        audit page do |results|
          Audit.new to_js, Results.new(results)
        end
      end

      private

      def audit(page)
        yield page.execute_async_script "#{METHOD_NAME}.apply(#{Core::JS_NAME}, arguments)", @context.to_json, @options.to_json
      end

      def to_js
        "#{METHOD_NAME}(#{@context}, #{@options}, callback);"
      end
    end
  end
end
