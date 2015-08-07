require 'forwardable'
require 'webdriver_script_adapter/exec_eval_script_adapter'
require 'webdriver_script_adapter/execute_async_script_adapter'

module Axe
  class Page
    extend Forwardable
    def_delegators :@browser, :execute_script, :execute_async_script

    def initialize(browser)
      @browser = ::WebDriverScriptAdapter::ExecuteAsyncScriptAdapter.wrap ::WebDriverScriptAdapter::ExecEvalScriptAdapter.wrap browser
    end
  end
end
