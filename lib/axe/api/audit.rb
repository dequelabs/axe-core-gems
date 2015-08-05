require 'forwardable'

require 'axe/api/a11y_check'
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
        @a11y_check.call Page.new page
      end

    end
  end
end
