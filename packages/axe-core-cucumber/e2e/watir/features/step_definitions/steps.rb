Given(/^I am a visitor$/) do
end

When(/^I visit "(.*?)"$/) do |url|
  @driver.page.goto url
end
