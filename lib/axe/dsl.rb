require 'axe/matchers'
require 'axe/expectation'

module Axe
  module DSL
    module_function

    # get the be_accessible matcher method
    extend Matchers

    def expect(page)
      AccessibilityExpectation.new page
    end
  end
end
