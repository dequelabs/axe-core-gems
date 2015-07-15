require 'forwardable'
require 'timeout'

module RSpec
  module A11y
    class Page

      def initialize(browser)
        @browser = browser
        expose_script_api
      end

      def wait_until
        # TODO make the timeout limit configurable
        ::Timeout.timeout(3) do
          sleep(0.1) until value = yield
          value
        end
      end

      private

      def expose_script_api
        extend script_api_adapter
      end

      def script_api_adapter
        @browser.respond_to?(:evaluate_script) ? CapybaraDelegate : WebDriverAdapter
      end

      # delegates to capybara api
      module CapybaraDelegate
        extend Forwardable
        def_delegator :@browser, :execute_script, :execute
        def_delegator :@browser, :evaluate_script, :evaluate
      end

      # adapts webdriver api to capybara-like api
      module WebDriverAdapter
        # executes script without returning result
        def execute(expression)
          @browser.execute_script expression
          nil
        end

        # returns result of executing script
        def evaluate(expression)
          @browser.execute_script "return #{expression}"
        end
      end

    end
  end
end
