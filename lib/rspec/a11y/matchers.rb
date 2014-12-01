require 'rspec/matchers'

RSpec::Matchers.define :be_accessible do
  match do |page|
    RSpec::Matchers::Custom::A11yHelper.run_test_for(page)
    results = JSON.parse(RSpec::Matchers::Custom::A11yHelper.get_test_results(page))
    results['violations'].count == 0
  end

  failure_message do |page|
    results = JSON.parse(RSpec::Matchers::Custom::A11yHelper.get_test_results(page))
    RSpec::Matchers::Custom::A11yHelper.message_for_results(results)
  end
end

RSpec::Matchers.define :be_accessible_within do |scope|
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

RSpec::Matchers.define :be_accessible_for_tag do |tag|
  match do |page|
    options = {runOnly: {type: "tag", values: [tag]}}
    RSpec::Matchers::Custom::A11yHelper.run_test_for(page, nil, options)
    results = JSON.parse(RSpec::Matchers::Custom::A11yHelper.get_test_results(page))
    results['violations'].count == 0
  end

  failure_message do |page|
    results = JSON.parse(RSpec::Matchers::Custom::A11yHelper.get_test_results(page))
    RSpec::Matchers::Custom::A11yHelper.message_for_results(results)
  end
end

RSpec::Matchers.define :be_accessible_for_rule do |rule|
  match do |page|
    options = {runOnly: {type: "rule", values: [rule]}}
    RSpec::Matchers::Custom::A11yHelper.run_test_for(page, nil, options)
    results = JSON.parse(RSpec::Matchers::Custom::A11yHelper.get_test_results(page))
    results['violations'].count == 0
  end

  failure_message do |page|
    results = JSON.parse(RSpec::Matchers::Custom::A11yHelper.get_test_results(page))
    RSpec::Matchers::Custom::A11yHelper.message_for_results(results)
  end
end
