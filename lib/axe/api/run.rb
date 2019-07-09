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
    class Run
      JS_NAME = "run"
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
        audit page do |results|
          Audit.new to_js, Results.new(results)
        end
      end

      private

      def audit(page)
        yield page.execute_async_script "#{METHOD_NAME}.apply(#{Core::JS_NAME}, arguments)", *js_args
      end

      def js_args
        [@context, @options]
          .reject(&:empty?)
          .map(&:to_json)
      end

      def to_js
        str_args = (js_args + ['callback']).join(', ')
        "#{METHOD_NAME}(#{str_args});"
      end
    end
  end
end
