require 'forwardable'
require 'timeout'

module Axe
  class Page
    extend Forwardable
    def_delegator :@browser, :execute_script
    def_delegator :@browser, :evaluate_script

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
      extend WebDriverAdapter unless @browser.respond_to? :evaluate_script
    end

    # adapts webdriver api to capybara-like api
    module WebDriverAdapter
      # executes script without returning result
      def execute_script(expression)
        @browser.execute_script expression
        nil
      end

      # returns result of executing script
      def evaluate_script(expression)
        @browser.execute_script "return #{expression}"
      end
    end

  end
end
