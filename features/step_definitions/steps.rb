When /^I visit "(.*?)"$/ do |url|
  visit url
end

When "I disable iframe auditing" do
  Axe.configure do |c|
    c.skip_iframes=true
  end
end

Then "there should be $n accessibility violations" do |violations|
  expect { expect(@page).to be_accessible }.to raise_error(/Found #{violations} accessibility violations/)
end
