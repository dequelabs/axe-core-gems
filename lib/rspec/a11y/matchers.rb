require 'rspec/matchers'

RSpec::Matchers.define :be_accessible do |scope|
  match do |page|
    RSpec::Matchers::Custom::A11yHelper.run_test_for(page, scope)
    results = JSON.parse(RSpec::Matchers::Custom::A11yHelper.get_test_results(page))
    results['violations'].count == 0
  end

  failure_message do |page|
    results = JSON.parse(RSpec::Matchers::Custom::A11yHelper.get_test_results(page))
    RSpec::Matchers::Custom::A11yHelper.message_for_results(results)
  end
end
