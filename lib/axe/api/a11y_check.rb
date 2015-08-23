require 'forwardable'
require 'json'

require 'chain_mail/chainable'

require 'axe/api'
require 'axe/api/audit'
require 'axe/api/context'
require 'axe/api/options'
require 'axe/api/results'
require 'axe/javascript_library'

module Axe
  module API
    class A11yCheck
      METHOD_NAME = "#{LIBRARY_IDENTIFIER}.a11yCheck"

      extend Forwardable
      def_delegators :@context, :within, :excluding
      def_delegator :@options, :rules_by_tags, :according_to
      def_delegator :@options, :run_rules, :checking
      def_delegator :@options, :run_only_rules, :checking_only
      def_delegator :@options, :skip_rules, :skipping
      def_delegator :@options, :custom_options, :with_options

      extend ChainMail::Chainable
      chainable :within, :excluding, :according_to, :checking, :checking_only, :skipping, :with_options

      def initialize
        @context = Context.new
        @options = Options.new
      end

      def call(page)
        inject_axe_lib page
        audit page do |results|
          Audit.new to_js, Results.new(results)
        end
      end

      private

      def inject_axe_lib(page)
        JavaScriptLibrary.new.inject_into page
      end

      def audit(page)
        yield page.execute_async_script "#{METHOD_NAME}.apply(#{LIBRARY_IDENTIFIER}, arguments)", @context.to_json, @options.to_json
      end

      def to_js
        "#{METHOD_NAME}(#{@context}, #{@options}, callback);"
      end
    end
  end
end
