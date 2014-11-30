require 'rspec/matchers'

RSpec::Matchers.define :be_accessible do |scope|
  match do |page|
    RSpec::Matchers::Custom::A11yHelper.run_test_for(page,scope)
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
        n['target'].each do |t|
          message += "    #{t}\n"
        end
        message += "    #{n['failureSummary'].gsub(/\n/, "\n    ")}\n"
      end
    end
    message
  end

  private

  def get_test_results
    json_result = page.evaluate_script("dqreReturn();")
    JSON.parse(json_result)
  end
end
