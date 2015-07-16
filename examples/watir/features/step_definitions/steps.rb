Given(/^I am a visitor$/) do
end

When(/^I visit "(.*?)"$/) do |url|
  @page.goto url
end
