require 'forwardable'
require 'timeout'
require 'axe/page/web_driver_to_capybara_page_adapter'

module Axe
  class Page
    extend Forwardable
    def_delegators :@browser, :evaluate_script, :execute_script

    def initialize(browser)
      @browser = browser
      adapt_webdriver_to_capybara
    end

    def wait_until
      # TODO make the timeout limit configurable
      ::Timeout.timeout(3) do
        sleep(0.1) until value = yield
        value
      end
    end

    private

    def adapt_webdriver_to_capybara
      WebDriverToCapybaraPageAdapter.adapt(self) unless @browser.respond_to? :evaluate_script
    end
  end
end
