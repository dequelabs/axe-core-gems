module Axe
  class Page
    # Capybara distinguishes eval from exec
    # (eval is a query, exec is a command)
    # this module makes webdriver act like capybara
    module WebDriverToCapybaraPageAdapter

      def self.adapt(page)
        page.extend WebDriverToCapybaraPageAdapter
      end

      # executes script without returning result
      def execute_script(script)
        @browser.execute_script script
        nil
      end

      # returns result of executing script
      def evaluate_script(script)
        @browser.execute_script "return #{script}"
      end
    end
  end
end
