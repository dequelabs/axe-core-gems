require 'axe/api'
require 'axe/api/a11y_check'
require 'axe/api/results'
require 'axe/javascript_library'

module Axe
  module API
    #TODO test this class
    class Audit

      def initialize(page)
        @page = page
      end

      def run(params)
        inject_axe_lib
        run_audit(params)
        parse_results
      end

      private

      def inject_axe_lib
        JavaScriptLibrary.new.inject_into @page
      end

      def run_audit(params)
        @page.execute A11yCheck.new(params).to_js
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
