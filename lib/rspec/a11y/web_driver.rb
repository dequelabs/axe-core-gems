require 'delegate'
require 'timeout'

module RSpec
  module A11y
    class WebDriver < SimpleDelegator

      # Tries #evaluate_script for Capybara,
      # falls back to #execute_script for WebDriver API (Selenium, Watir)
      def evaluate(expression)
        respond_to?(:evaluate_script) ? evaluate_script(expression) : execute_script(expression)
      end

      def wait_until
        # TODO make the timeout limit configurable
        ::Timeout.timeout(3) do
          sleep(0.1) until value = yield
          value
        end
      end

    end
  end
end
