module RSpec
  module Matchers
    module Custom
      module A11yHelper

        def self.run_test_for(page, scope=nil)
          scope = scope || "body"
          script = "dqre.a11yCheck('#{scope}', null, function(result){window.dqreResult = JSON.stringify(result);});"
          self.execute_script(page, script)
        end

        def self.get_test_results(page)
          script = "dqreReturn();"
          self.evaluate_script(page, script)
        end

        private

        def self.execute_script(page, script)
          # This is a simple alias so it can be overridden if necessary
          page.execute_script(script)
        end

        def self.evaluate_script(page, script)
          # This is a simple alias so it can be overridden if necessary
          # Tries #evaluate_script for Capybara, falls back to #execute_script for Watir
          page.respond_to?(:evaluate_script) ? page.evaluate_script(script) : page.execute_script(script)
        end
      end
    end
  end
end
