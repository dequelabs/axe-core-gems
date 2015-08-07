require 'dumb_delegator'
require 'securerandom'
require 'timeout'
require 'webdriver_script_adapter/exec_eval_script_adapter'

module WebDriverScriptAdapter
  module ScriptWriter
    module_function

    def async_results_identifier(key)
      "window['#{key}']"
    end

    def callback(resultsIdentifier)
      "function(returnValue){ #{resultsIdentifier} = returnValue; }"
    end

    def async_wrapper(script, *args)
      ";(function(){ #{script} })(#{args.join(', ')});"
    end
  end

  class ExecuteAsyncScriptAdapter < ::DumbDelegator
    def self.wrap(driver)
      new ExecEvalScriptAdapter.wrap driver
    end

    def execute_async_script(script, *args)
      results = ScriptWriter.async_results_identifier(::SecureRandom.uuid)
      execute_script ScriptWriter.async_wrapper(script, *args, ScriptWriter.callback(results))
      wait_until { evaluate_script results }
    end

    private

    def wait_until
      # TODO make the timeout limit configurable
      ::Timeout.timeout(3) do
        sleep(0.1) until value = yield
        value
      end
    end
  end
end
