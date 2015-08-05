require 'forwardable'
require 'axe/page/web_driver_to_capybara_page_adapter'
require 'axe/page/execute_async_script_adapter'

module Axe
  class Page
    extend Forwardable
    def_delegators :@browser, :evaluate_script, :execute_script, :execute_async_script

    def initialize(browser)
      @browser = ExecuteAsyncScriptAdapter.wrap WebDriverToCapybaraPageAdapter.wrap browser
    end
  end
end
