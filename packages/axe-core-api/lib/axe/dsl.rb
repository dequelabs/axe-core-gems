require_relative "./matchers/be_axe_clean"
require_relative "./expectation"

module Axe
  module DSL
    module_function

    # get the be_axe_clean matcher method
    extend Matchers

    def expect(page)
      AccessibilityExpectation.new page
    end
  end
end
