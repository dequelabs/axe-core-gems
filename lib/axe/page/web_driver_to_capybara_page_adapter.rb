require 'dumb_delegator'

module Axe
  class Page
    # Capybara distinguishes eval from exec
    # (eval is a query, exec is a command)
    # this decorator makes webdriver act like capybara
    class WebDriverToCapybaraPageAdapter < ::DumbDelegator

      def self.wrap(driver)
        driver.respond_to?(:evaluate_script) ? driver : new(driver)
      end

      # executes script without returning result
      def execute_script(script)
        super
        nil
      end

      # returns result of executing script
      def evaluate_script(script)
        __getobj__.execute_script "return #{script}"
      end
    end
  end
end
