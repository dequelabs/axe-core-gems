require 'forwardable'

require 'axe/api'
require 'axe/api/a11y_check'
require 'axe/javascript_library'
require 'axe/page'

module Axe
  module API
    class Audit
      extend Forwardable

      def_delegators :@a11y_check, :include, :exclude, :rules_by_tags, :run_rules, :skip_rules, :run_only_rules, :custom_options

      def initialize
        @a11y_check = A11yCheck.new
      end

      def run_against(page)
        @page = Page.new(page)

        inject_axe_lib

        @a11y_check.call(@page)
      end

      private

      def inject_axe_lib
        JavaScriptLibrary.new.inject_into @page
      end

    end
  end
end
