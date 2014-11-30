require 'rspec/matchers'

RSpec::Matchers.define :be_accessible do |scope|
  match do |page|
    RSpec::Matchers::Custom::A11yHelper.run_test_for(page, scope)
    results = JSON.parse(RSpec::Matchers::Custom::A11yHelper.get_test_results(page))
    results['violations'].count == 0
  end

  failure_message do |page|
    results = JSON.parse(RSpec::Matchers::Custom::A11yHelper.get_test_results(page))
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
end
