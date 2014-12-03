require 'json'

module CustomA11yMatchers
  class BeAccessible

    def matches?(page)
      @page = page

      execute_test_script
      evaluate_test_results

      violations_count == 0
    end

    def failure_message
      message = "Found #{violations_count} accessibility #{violations_count == 1 ? 'violation' : 'violations'}:\n"
      @results['violations'].each_with_index do |v, i|
        message += "  #{i+1}) #{v['help']}: #{v['helpUrl']}\n"
        v['nodes'].each do |n|
          message += "    #{n['html']}\n"
          n['target'].each do |t|
            message += "    #{t}\n"
          end
          message += "    #{n['failureSummary'].gsub(/\n/, "\n    ")}\n"
        end
      end
      message
    end

    private

    def execute_test_script
      @page.execute_script(script_for_execute)
    end

    def script_for_execute
      "dqre.a11yCheck(document, null, function(result){dqre.rspecResult = JSON.stringify(result);});"
    end

    def evaluate_test_results
      # Tries #evaluate_script for Capybara, falls back to #execute_script for Watir
      results = @page.respond_to?(:evaluate_script) ? @page.evaluate_script(script_for_evaluate) : @page.execute_script(script_for_evaluate)
      @results = JSON.parse(results)
    end

    def script_for_evaluate
      "(function(){return dqre.rspecResult;})()"
    end

    def violations_count
      @results['violations'].count
    end
  end

  def be_accessible
    BeAccessible.new
  end
end
