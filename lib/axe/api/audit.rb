require 'forwardable'

require 'axe/api'
require 'axe/api/a11y_check'
require 'axe/api/context'
require 'axe/api/options'
require 'axe/api/results'
require 'axe/javascript_library'
require 'axe/page'

module Axe
  module API
    #TODO test this class
    class Audit
      extend Forwardable

      def_delegators :@context, :include, :exclude
      def_delegators :@options, :rules_by_tags, :run_only_rules

      def initialize
        @context = Context.new
        @options = Options.new
      end

      def run_against(page)
        @page = Page.new(page)

        inject_axe_lib
        run_audit
        parse_results
      end

      private

      def inject_axe_lib
        JavaScriptLibrary.new.inject_into @page
      end

      def run_audit
        @page.execute A11yCheck.new(context: @context, options: @options).to_js
      end

      def parse_results
        Results.from_hash audit_results
      end

      def audit_results
        @page.wait_until { @page.evaluate(RESULTS_IDENTIFIER) }
      end
    end
  end
end
