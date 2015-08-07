require 'dumb_delegator'
require 'securerandom'
require 'timeout'
require 'webdriver_script_adapter/exec_eval_script_adapter'

module WebDriverScriptAdapter
  class << self
    attr_accessor :generate_async_results_identifier, :max_wait_time, :wait_interval

    def configure
      yield self
    end
  end

  module ScriptWriter
    module_function

    def async_results_identifier
      "window['#{ WebDriverScriptAdapter.generate_async_results_identifier.call }']"
    end

    def callback(resultsIdentifier)
      "function(returnValue){ #{resultsIdentifier} = returnValue; }"
    end

    def async_wrapper(script, *args)
      ";(function(){ #{script} })(#{args.join(', ')});"
    end
  end

  module Patiently
    module_function

    def wait_until
      ::Timeout.timeout(WebDriverScriptAdapter.max_wait_time) do
        sleep(WebDriverScriptAdapter.wait_interval) until value = yield
        value
      end
    end
  end

  class ExecuteAsyncScriptAdapter < ::DumbDelegator
    def self.wrap(driver)
      new ExecEvalScriptAdapter.wrap driver
    end

    def execute_async_script(script, *args)
      results = ScriptWriter.async_results_identifier
      execute_script ScriptWriter.async_wrapper(script, *args, ScriptWriter.callback(results))
      Patiently.wait_until { evaluate_script results }
    end
  end
end

WebDriverScriptAdapter.configure do |c|
  c.generate_async_results_identifier = -> { SecureRandom.uuid }
  c.max_wait_time = 3
  c.wait_interval = 0.1
end
