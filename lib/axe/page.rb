require 'forwardable'
require 'webdriver_script_adapter/exec_eval_script_adapter'
require 'webdriver_script_adapter/execute_async_script_adapter'

module Axe
  class Page
    extend Forwardable
    def_delegators :@browser, :execute_script, :execute_async_script

    def initialize(browser)
      @browser = wrap_exec_async wrap_exec_eval browser
    end

    private

    # ensure driver has #execute_async_script
    def wrap_exec_async(driver)
      ::WebDriverScriptAdapter::ExecuteAsyncScriptAdapter.wrap driver
    end

    # ensure driver has #execute_script and #evaluate_script
    def wrap_exec_eval(driver)
      ::WebDriverScriptAdapter::ExecEvalScriptAdapter.wrap driver
    end
  end
end
