module Axe
  module API
    LIBRARY_IDENTIFIER = "axe"
    RESULTS_IDENTIFIER = LIBRARY_IDENTIFIER + ".rspecResult"
  end
end

# method
require 'axe/api/a11y_check'

# parameters
require 'axe/api/context'
require 'axe/api/options'

# results
require 'axe/api/results'
