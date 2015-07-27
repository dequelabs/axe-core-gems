require 'axe/api/a11y_check'
require 'axe/javascript_library'

module Axe
  module API
    class Audit

      def initialize(page)
        @page = page
      end

      def run(params)
        inject_axe_lib
        run_audit(params)
      end

      private

      def inject_axe_lib
        JavaScriptLibrary.new.inject_into @page
      end

      def run_audit(params)
        @page.execute(A11yCheck.new(params).to_js)
      end
    end
  end
end
