RSpec::Matchers.define :be_accessible do |scope|
  match do |page|
    run_test_for(scope)
    results = get_test_results
    results['violations'].count == 0
  end

  failure_message do |page|
    results = get_test_results
    violation_count = results['violations'].count

    message = "Found #{violation_count} accessibility #{violation_count == 1 ? 'violation' : 'violations'}:\n"
    results['violations'].each do |v|
      message += "  #{v['help']}: #{v['helpUrl']}\n"
      v['nodes'].each do |n|
        message += "    #{n['html']}\n"
        message += "    #{n['failureSummary'].gsub(/\n/, "\n    ")}\n"
      end
    end
    message
  end

  private

  def run_test_for(scope)
    page.execute_script("dqre.a11yCheck('#{scope || 'body'}', null, function(result){window.dqreResult = JSON.stringify(result);});")
  end

  def get_test_results
    json_result = page.evaluate_script("dqreReturn();")
    JSON.parse(json_result)
  end
end
