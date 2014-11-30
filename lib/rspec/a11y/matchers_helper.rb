module RSpec
  module Matchers
    module Custom
      module A11yHelper

        def self.run_test_for(page, scope="body")
          script = "dqre.a11yCheck('#{scope}', null, function(result){window.dqreResult = JSON.stringify(result);});"
          self.execute_script(page, script)
        end

        private

        def self.execute_script(page, script)
          # This is a simple alias so it can be stubbed and overridden if necessary
          page.execute_script(script)
        end
      end
    end
  end
end
