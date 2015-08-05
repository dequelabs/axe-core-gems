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

    def exec_async(script, *args)
      @browser.execute_script p <<-SCRIPT
      (function(){
      #{script}
      })(#{args.join(',')}, #{callback})
      SCRIPT
      wait_until { evaluate_script "axe.a11yCheck.asyncResult" }
    end

    private

    def callback
      "function(results){ axe.a11yCheck.asyncResult = results; }"
    end

    def adapt_webdriver_to_capybara
      WebDriverToCapybaraPageAdapter.adapt(self) unless @browser.respond_to? :evaluate_script
    end
  end
end
