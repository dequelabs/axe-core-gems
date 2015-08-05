require 'forwardable'
require 'timeout'
require 'axe/page/web_driver_to_capybara_page_adapter'

module Axe
  class Page
    extend Forwardable
    def_delegator :@browser, :execute_script
    def_delegator :@browser, :evaluate_script

    def initialize(browser)
      @browser = browser
      WebDriverToCapybaraPageAdapter.adapt(self) unless @browser.respond_to? :evaluate_script
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
