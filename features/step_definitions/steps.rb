When /^I visit "(.*?)"$/ do |url|
  visit url
end

Then "there should be $n accessibility violations" do |violations|
  expect { expect(@page).to Axe::Matchers::BeAccessible.new }.to raise_error(/Found #{violations} accessibility violations/)
end
