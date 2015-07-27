require 'axe/javascript_library'

module Axe
  module API
    class Audit

      def initialize(page)
        @page = page
      end

      def run
        inject_axe_lib
      end

      private

      def inject_axe_lib
        JavaScriptLibrary.new.inject_into @page
      end

    end
  end
end
