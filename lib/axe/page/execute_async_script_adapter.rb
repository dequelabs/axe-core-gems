require 'securerandom'
require 'timeout'

module Axe
  class Page
    module ExecuteAsyncScriptAdapter
      def execute_async_script(script, *args)
        results = async_results_identifier(SecureRandom.uuid)
        execute_script async_wrapper(script, args, results)
        wait_until { evaluate_script results }
      end

      private

      def async_results_identifier(key)
        "window['#{key}']"
      end

      def async_wrapper(script, args, resultsIdentifier)
        ";(function(){ #{script} })(#{args.join(',')}, function(returnValue){ #{resultsIdentifier} = returnValue; });"
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
end
