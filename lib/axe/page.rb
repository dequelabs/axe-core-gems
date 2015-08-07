require 'forwardable'
require 'axe/page/web_driver_to_capybara_page_adapter'
require 'axe/page/execute_async_script_adapter'

module Axe
  class Page
    extend Forwardable
    def_delegators :@browser, :evaluate_script, :execute_script

    def initialize(browser)
      @browser = browser
      adapt_webdriver_to_capybara
      adapt_async_script_executor
    end

    private

    def adapt_webdriver_to_capybara
      extend WebDriverToCapybaraPageAdapter unless @browser.respond_to? :evaluate_script
    end

    def adapt_async_script_executor
      extend ExecuteAsyncScriptAdapter
    end
  end
end
